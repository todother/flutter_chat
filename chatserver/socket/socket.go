package socket

import (
	"com.todother/DataEntity"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"github.com/gorilla/websocket"
	"github.com/kataras/iris/v12"
	tsgutils "github.com/typa01/go-utils"
	"net/http"
)

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
	To      string
	Msg     []byte
	MsgType int
}

type ReceiveMsgType struct {
	From    string `json:"from"`
	To      string `json:"to"`
	Content string `json:"content"`
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
		}
	}
}

func RunWebSocket(app *iris.Application) {

	app.Get("/socket", NewSocketClient)

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
	go newClient.ProcessMsg()
	returnConn := DataEntity.ReturnConn{ConnId: connId}
	connJson, _ := json.Marshal(&returnConn)
	returnValue := DataEntity.SocketReturnValue{
		"onConn", string(connJson),
	}
	var receiveMsg ReceiveMsgType
	receiveMsg.To = connId

	resultJson, _ := json.Marshal(returnValue)
	message := BroadcastMessageType{
		To:      receiveMsg.To,
		Msg:     resultJson,
		MsgType: websocket.TextMessage,
	}
	newClient.Broadcast <- &message

}

func (c *Client) ReadMessage() {
	fmt.Println("read msg")
	_, msg, err := c.Client.ReadMessage()
	fmt.Sprintf("read in msg ,%s", string(msg))
	var receiveMsg ReceiveMsgType
	if err != nil {
		fmt.Println(err)
	}
	err = json.Unmarshal(msg, &receiveMsg)
	fmt.Sprintf("the value from client is %s,", string(msg))
	if err != nil {
		fmt.Println(err)
	}
	result, err := base64.StdEncoding.DecodeString("this is from server listnere")
	message := BroadcastMessageType{
		To:      receiveMsg.To,
		Msg:     result,
		MsgType: websocket.BinaryMessage,
	}
	c.Broadcast <- &message
}
