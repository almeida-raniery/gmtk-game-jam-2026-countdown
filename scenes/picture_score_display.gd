extends PanelContainer

@export var letter_badge: Dictionary[String, Texture]

@onready var picture_result = $VboxContainer/PictureFrame/PictureResult
@onready var ranking_badge = $VboxContainer/PictureFrame/RankingBadge
@onready var ranking_label = $VboxContainer/PictureFrame/RankingBadge/RankingLabel
@onready var success_vignette = $SuccessVignette
@onready var failure_vignette = $FailureVignette
@onready var score_label = $VboxContainer/PictureFrame/ScoreLabel

func show_final_score(score_info: PictureScoreInfo):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	picture_result.texture = score_info.result_picture
	
	if score_info.final_score >= 1000:
		ranking_label.text = "S"
		ranking_badge.texture = letter_badge["S"]
	elif score_info.final_score >= 600:
		ranking_label.text = "A"
		ranking_badge.texture = letter_badge["A"]
	elif  score_info.final_score >= 400:
		ranking_label.text = "B"
		ranking_badge.texture = letter_badge["B"]
	elif score_info.final_score >= 0:
		ranking_label.text = "C"
		ranking_badge.texture = letter_badge["C"]
	else:
		ranking_label.text = "F"
		ranking_badge.texture = letter_badge["F"]
	
	score_label.text = "Score: " + str(score_info.final_score) + " pts"
	
	if score_info.success:
		success_vignette.play()
	else:
		failure_vignette.play()
	
	visible = true
