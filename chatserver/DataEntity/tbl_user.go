package DataEntity

type Tbl_User struct {
	UserId   string `gorm:"column:userId;primary_key"`
	UserName string `gorm:"column:username"`
	TelNo    string `gorm:"column:telno"`
	Imei     string `gorm:"column:imei"`
}
