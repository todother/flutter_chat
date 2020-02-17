package Handler

import (
	"com.todother/DataAccess"
	"com.todother/DataEntity"
	tsgutils "github.com/typa01/go-utils"
)

func GetUserInfo(userId string) *DataEntity.Tbl_User {
	user := DataAccess.GetUserInfo(userId)
	return user
}

func GetPosts(userId string) *[]DataEntity.UserPosts {
	rows := DataAccess.GetPosts(userId)
	return rows
}

func AddNewUser(userName string) *DataEntity.Tbl_User {
	user := DataEntity.Tbl_User{}
	user.UserId = tsgutils.UUID()
	user.UserName = userName
	DataAccess.AddNewUser(&user)
	return &user
}

func UpdateUserName() {
	user := DataEntity.Tbl_User{
		UserId:   "aaa",
		UserName: "",
	}
	DataAccess.UpdateUserName(&user)
}

func TestUpdateUserInfo() {
	user := DataEntity.Tbl_User{
		UserId:   "1234",
		UserName: "aaa",
	}
	DataAccess.TestUpdateUserInfo(&user)
}

func IfUserExistsByTelNo(telNo string) bool {
	return DataAccess.IfUserExistsByTelNo(telNo)
}
