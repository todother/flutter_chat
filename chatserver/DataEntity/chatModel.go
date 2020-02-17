package DataEntity

type ChatModel struct {
	Sender        int     `json:"sender"`
	Content       string  `json:"content"`
	AvatarUrl     string  `json:"avatarUrl"`
	ChatType      int     `json:"chatType"`
	VoiceDuration int     `json:"voiceDuration"`
	Address       string  `json:"address"`
	Title         string  `json:"title"`
	LocationImg   string  `json:"locationImg"`
	ImgHeight     float64 `json:"imgHeight"`
	ImgWidth      float64 `json:"imgWidth"`
	VideoPath     string  `json:"videoPath"`
}
