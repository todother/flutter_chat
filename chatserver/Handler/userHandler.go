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

func GetAllUsers() *[]DataEntity.Tbl_User {
	users := DataAccess.GetAllUsers()
	return users
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

func IfUserExistsByTelNo(telNo string, imei string, pushId string) (bool, *string) {
	ifexists, userId := DataAccess.IfUserExistsByTelNo(telNo, imei, pushId)
	if !ifexists {
		var user DataEntity.Tbl_User
		tempId := tsgutils.UUID()
		userId = &tempId
		user.UserId = tempId
		user.UserName = "newuser"
		user.Avatar = "https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_is.jpg"
		user.Imei = &imei
		user.TelNo = telNo
		user.PushId = &pushId
		DataAccess.AddNewUser(&user)
	}
	return ifexists, userId
}

func IFSameIMEI(userId string, imei string) bool {
	return DataAccess.IfSameIMEI(userId, imei)
}
