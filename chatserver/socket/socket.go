package socket

import (
	"com.todother/DataAccess"
	"com.todother/DataEntity"
	"encoding/json"
	"fmt"
	"github.com/gorilla/websocket"
	"github.com/kataras/iris/v12"
	tsgutils "github.com/typa01/go-utils"
	"net/http"
	"time"
)

func RunWebSocket(app *iris.Application) {

	app.Get("/socket", NewSocketClient)

}

var upgrader = websocket.Upgrader{
	WriteBufferSize: 10240,
	ReadBufferSize:  10240,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var Clients = make(map[string]*Client)

type Client struct {
	Client    *websocket.Conn
	Broadcast chan *BroadcastMessageType
}

type BroadcastMessageType struct {
	To          string
	Msg         []byte
	MsgType     int
	ContentType int
}

type ReceiveMsgType struct {
	FromUser    string `json:"fromUser"`
	ToUser      string `json:"toUser"`
	Content     string `json:"content"`
	GrpId       string `json:"grpId"`
	ContentType int    `json:"contentType"`
}

func (c *Client) AddToClients(clients map[string]*websocket.Conn) {
	connId := tsgutils.UUID()
	clients[connId] = c.Client
}

func (c *Client) ProcessMsg() {
	for {
		select {
		case data := <-c.Broadcast:
			toClient := Clients[data.To]
			err := toClient.Client.WriteMessage(websocket.TextMessage, data.Msg)
			fmt.Println(data.Msg)
			if err != nil {
				fmt.Println(err)
			}
		default:
			time.Sleep(time.Second * 2)
		}
	}
}

///1 on 1 chat
func (c *Client) ReadIndMessage() {

	for {
		fmt.Println("read msg")
		_, msg, err := c.Client.ReadMessage()
		fmt.Sprintf("read in msg ,%s", string(msg))
		var receiveMsg ReceiveMsgType
		if err != nil || len(msg) == 0 {
			fmt.Println(err)
			return
		}
		returnValue := DataEntity.SocketReturnValue{
			CallbackName: "onReceiveMsg",
			JsonResponse: string(msg),
		}
		err = json.Unmarshal(msg, &receiveMsg)
		res, err := json.Marshal(&returnValue)
		if err != nil {
			fmt.Println(err)
		}
		//var user DataEntity.Tbl_User
		user := DataAccess.GetUserInfo(receiveMsg.ToUser)
		//result, err := base64.StdEncoding.DecodeString("this is from server listnere")
		message := BroadcastMessageType{
			To:      *user.ConnId,
			Msg:     res,
			MsgType: websocket.TextMessage,
		}
		c.Broadcast <- &message

	}

}

func NewSocketClient(ctx iris.Context) {
	w := ctx.ResponseWriter()
	r := ctx.Request()
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println(err)
	}
	connId := tsgutils.GUID()
	newClient := Client{conn, make(chan *BroadcastMessageType)}
	Clients[connId] = &newClient
	go newClient.ReadIndMessage()
	go newClient.ProcessMsg()
	returnConn := DataEntity.ReturnConn{ConnId: connId}
	connJson, _ := json.Marshal(&returnConn)
	returnValue := DataEntity.SocketReturnValue{
		"onConn", string(connJson),
	}
	var receiveMsg ReceiveMsgType
	receiveMsg.ToUser = connId

	resultJson, _ := json.Marshal(returnValue)
	go DataAccess.UpdateConnId(ctx.URLParam("userId"), connId)
	message := BroadcastMessageType{
		To:      receiveMsg.ToUser,
		Msg:     resultJson,
		MsgType: websocket.TextMessage,
	}
	newClient.Broadcast <- &message
}
