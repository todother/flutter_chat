package controller

import "github.com/kataras/iris/v12"

//return chat info
func GetChatInfo(ctx iris.Context)  {
	ctx.WriteString("this is chat content")
}
