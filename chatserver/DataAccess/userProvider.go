package DataAccess

import (
	"com.todother/DBHelper"
	"com.todother/DataEntity"
	"fmt"
	"github.com/typa01/go-utils"
)

func GetUserInfo(userId string) *DataEntity.Tbl_User {
	db := DBHelper.NewInstance()
	defer db.Close()
	var user DataEntity.Tbl_User
	rows := db.Where("userId=?", userId).Find(&user)
	if rows.Error != nil {
		panic(rows.Error.Error())
	}
	return &user
}

func AddNewUser(user *DataEntity.Tbl_User) {
	db := DBHelper.NewInstance()
	defer db.Close()

	tx := db.Begin()

	//user:=
	user.UserId = tsgutils.UUID()

	err := tx.Create(user).Error
	if err != nil {
		tx.Rollback()
		return
	}
	tx.Commit()

}

func TestUpdateUserInfo(user *DataEntity.Tbl_User) {
	db := DBHelper.NewInstance()
	defer db.Close()
	//user.UserName = "updateindb"
	//user.Imei = "1234"
	//user.TelNo = "12345"
	////err := db.Save(user).Error
	////if err != nil {
	////	fmt.Println(err)
	////}
	tx := db.Begin()
	//
	err := tx.Model(&user).UpdateColumn("username", "testUser").Where("userId=?", &user.UserId).Error
	//
	//sql := tx.Model(user).Where("username=?", user.UserName).UpdateColumn("userName", "testUser").QueryExpr()
	//fmt.Println(sql)
	if err != nil {
		tx.Rollback()
		return
	}
	tx.Commit()
}

func GetPosts(userId string) *[]DataEntity.UserPosts {

	db := DBHelper.NewInstance()

	defer db.Close()

	var user DataEntity.Tbl_User
	var count int64
	db.Where("userId=?", "aaa").Set("gorm:queryOption", "FOR UPDATE").Find(&user)
	//db.Delete(user)
	user.UserName = "doneemay"

	db.Save(&user)
	var posts []DataEntity.UserPosts
	rows := db.Table("tbl_posts as tp").
		Select("tp.postsId,tp.postsMaker,tu.username as postsMakerName,tp.postsContent").
		Joins("left join tbl_user tu on tp.postsMaker=tu.userId").
		Where("tu.userId=?", userId).
		Order("tp.postsId desc").Find(&posts).Count(&count)
	err := rows.Error
	if err != nil {
		fmt.Println(err)
	}
	_ = rows
	return &posts
}

func UpdateUserName(user *DataEntity.Tbl_User) {
	db := DBHelper.NewInstance()
	defer db.Close()
	tx := db.Begin()
	tx.Set("gorm:query_option", "FOR UPDATE").Where("userId=?", "aaa").Find(user)
	if user.UserName == "fromA" {
		user.UserName = "fromserver"
		err := tx.Save(user).Error
		if err != nil {
			tx.Rollback()
		}
	}
	tx.Commit()
}

func IfUserExistsByTelNo(telNo string) bool {
	db := DBHelper.NewInstance()
	defer db.Close()
	var user DataEntity.Tbl_User

	ifFound := db.Where("telno=?", telNo).Find(&user).RecordNotFound()
	return !ifFound
}
