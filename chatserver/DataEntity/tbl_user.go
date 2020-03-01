package DataEntity

import "time"

type Tbl_User struct {
	UserId        string     `gorm:"column:userId;primary_key" json:"userId"`
	UserName      string     `gorm:"column:userName" json:"userName"`
	TelNo         string     `gorm:"column:telNo" json:"telNo"`
	Imei          *string    `gorm:"column:imei"`
	ConnId        *string    `gorm:"column:connId"`
	Avatar        string     `gorm:"column:avatar" json:"avatar"`
	PushId        *string    `gorm:"column:pushId"`
	LastLoginDate *time.Time `gorm:"column:lastLoginDate"`
}
