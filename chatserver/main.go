package main

import (
	"com.todother/socket"
	"github.com/kataras/iris/v12"

	"com.todother/controller"
	"github.com/kataras/iris/v12/middleware/logger"
	"github.com/kataras/iris/v12/middleware/recover"
)

func main() {
	app := iris.Default()
	controller.Register(app)

	app.Logger().SetLevel("debug")
	app.Use(recover.New())
	app.Use(logger.New())
	app.Handle("GET", "/", func(ctx iris.Context) {
		ctx.HTML("<h1>Welcome</h1>")
	})

	app.Get("/ping", func(ctx iris.Context) {
		ctx.WriteString("pong")
	})

	app.Get("/hello", func(ctx iris.Context) {
		ctx.JSON(iris.Map{"message": "Hello Iris!"})
	})

	socket.RunWebSocket(app)

	v1 := app.Party("/v1")
	{
		v1.Get("/aaa", showHello)
		v1.Get("/bbb", showThankYou)
	}

	//socket.RunWebSocket(app)
	app.Run(iris.Addr(":5000"), iris.WithoutServerError(iris.ErrServerClosed))

}

func showHello(ctx iris.Context) {
	ctx.WriteString("hello")
}

func showThankYou(ctx iris.Context) {
	ctx.WriteString("thank you")
}
