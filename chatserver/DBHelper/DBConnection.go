package DBHelper

import (
	"com.todother/AesHelper"
	"fmt"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/spf13/viper"
)

type DBConnectParam struct {
	UserName string
	DBServer string
	PWD      string
	DBName   string
}

func NewInstance() *gorm.DB {
	config := viper.New()
	config.SetConfigName("config")
	//viper.SetConfigName("config")
	config.SetConfigType("yaml")
	config.AddConfigPath("./")
	config.ReadInConfig()
	var configData DBConnectParam
	if err := config.Unmarshal(&configData); err != nil {
		fmt.Println(err.Error())
	}
	decryptedPwd := AesHelper.AESDecrypt(configData.PWD)
	db, err := gorm.Open("mysql", fmt.Sprintf("%s:%s@(%s)/%s?charset=utf8&parseTime=True&loc=Local", configData.UserName, decryptedPwd, configData.DBServer, configData.DBName))
	db.SingularTable(true)
	if err != nil {
		fmt.Println(err)
	}

	return db
}
