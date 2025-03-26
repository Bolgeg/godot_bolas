extends Node2D

signal game_over(score)

var lost:=false
var paused:=false

func _ready() -> void:
	%PauseScreen.visible=false

func _process(_delta: float) -> void:
	%LivesLabel.text=str(%Player.lives)
	%ScoreLabel.text=str(%Player.score)
	if %Player.lives<=0 and not lost:
		%Player.lives=0
		game_over.emit(%Player.score)
		pause()
		lost=true
	if not lost:
		if Input.is_action_just_pressed("pause"):
			if paused:
				resume()
				%Objects.visible=true
				%PauseScreen.visible=false
			else:
				pause()
				%Objects.visible=false
				%PauseScreen.visible=true

func pause():
	for child in get_children():
		child.process_mode=Node.PROCESS_MODE_DISABLED
	paused=true
func resume():
	for child in get_children():
		child.process_mode=Node.PROCESS_MODE_INHERIT
	paused=false

func destroy():
	queue_free()
