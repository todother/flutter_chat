package DataEntity

import "time"

///1 on 1 chat
type Tbl_IndChat struct {
	ChatId      string     `gorm:"column:chatId"`
	SenderId    string     `gorm:"column:senderId"`
	ToId        string     `gorm:"column:toId"`
	ChatContent string     `gorm:"column:chatContent"`
	ChatTime    *time.Time `gorm:"column:chatTime"`
	ContentType int        `gorm:"column:contentType"`
}
