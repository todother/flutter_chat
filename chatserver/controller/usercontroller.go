package controller

import (
	"com.todother/Handler"
	"encoding/json"
	"fmt"
	"github.com/kataras/iris/v12"
)

func GetUserInfo(ctx iris.Context) {
	userId := ctx.URLParam("userId")
	user := Handler.GetUserInfo(userId)
	ctx.JSON(*user)

}

func GetPosts(ctx iris.Context) {
	userId := ctx.URLParam("userId")
	rows := Handler.GetPosts(userId)
	ctx.JSON(rows)
}

func GetAllUsers(ctx iris.Context) {
	users := Handler.GetAllUsers()
	ctx.JSON(*users)
}

type UrlValue struct {
	UrlPath string `json:"urlPath"`
}

func AddNewUser(ctx iris.Context) {

	userUrl := ctx.URLParam("userName")
	fmt.Println(userUrl)
	userName := ctx.FormValue("userName")
	var url UrlValue
	user := Handler.AddNewUser(userName)
	body, _ := ctx.GetBody()
	jsStr := string(body)
	fmt.Println(jsStr)
	json.Unmarshal(body, &url)

	ctx.JSON(user)
}

func UpdateUserName(ctx iris.Context) {
	Handler.UpdateUserName()
	ctx.JSON("finish")
}

func TestUpdateUserInfo(ctx iris.Context) {
	Handler.TestUpdateUserInfo()
	ctx.WriteString("finish")
}

func IfUserExistsByTelNo(ctx iris.Context) {
	telNo := ctx.URLParam("telNo")
	IMEI := ctx.URLParam("imei")
	pushId := ctx.URLParamDefault("pushId", "")
	ifFound, userId := Handler.IfUserExistsByTelNo(telNo, IMEI, pushId)

	ctx.JSON(iris.Map{
		"result": ifFound,
		"userId": *userId,
	})
}

func IFSameIMEI(ctx iris.Context) {
	IMEI := ctx.URLParam("IMEI")
	LoginId := ctx.URLParam("loginId")
	IFSame := Handler.IFSameIMEI(LoginId, IMEI)
	ctx.JSON(iris.Map{
		"ifSame": IFSame,
	})
}
