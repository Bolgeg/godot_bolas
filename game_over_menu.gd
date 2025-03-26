extends Control

func _ready() -> void:
	visible=false

func start(score):
	%GameOverTimer.start()
	%GameOverMenuPanel.visible=false
	%ScoreLabel.text=str(score)

func _process(_delta: float) -> void:
	var t:=1.0
	if %GameOverTimer.wait_time>0:
		t=1-%GameOverTimer.time_left/%GameOverTimer.wait_time
	%BackgroundFade.color=lerp(Color(0,0,0,0),Color(0,0,0,0.75),sqrt(t))
	if t==1:
		%GameOverMenuPanel.visible=true
	
