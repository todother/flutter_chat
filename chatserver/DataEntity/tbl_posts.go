package DataEntity

type TBL_POSTS struct {
	PostsId      string `gorm:"column:postsId"`
	PostsMaker   string `gorm:"column:postsMaker"`
	PostsContent string `gorm:"column:postsContent"`
}
