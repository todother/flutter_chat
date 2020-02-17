package DataEntity

type UserPosts struct {
	PostsId        string `gorm:"column:postsId"`
	PostsMaker     string `gorm:"column:postsMaker"`
	PostsMakerName string `gorm:"column:postsMakerName"`
	PostsContent   string `gorm:"column:postsContent"`
}
