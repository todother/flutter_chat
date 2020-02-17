package controller

import "github.com/kataras/iris/v12"

func Register(app *iris.Application) {
	userController := app.Party("/user")
	{
		userController.Get("/getUserInfo", GetUserInfo)
		userController.Get("/getPosts", GetPosts)
		userController.Post("/addNewUser", AddNewUser)
		userController.Get("/updateUserName", UpdateUserName)
		userController.Get("/testUpdate", TestUpdateUserInfo)
		userController.Get("/ifUserExistsByTelNo", IfUserExistsByTelNo)
	}

	chatController := app.Party("/chat")
	{
		chatController.Get("/getChatInfo", GetChatInfo)
	}
}
