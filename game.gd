extends Node2D

signal game_over(score)

var lost:=false
var paused:=false
var game_time:=0.0

func _ready() -> void:
	%PauseScreen.visible=false

func _process(delta: float) -> void:
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
	if not lost and not paused:
		game_time+=delta
		update_game_speed()

func update_game_speed():
	const MAX_GAME_SPEED:=10.0
	const MAX_GAME_TIME_FOR_SPEED:=300.0
	var speed_progress=game_time/MAX_GAME_TIME_FOR_SPEED
	if speed_progress>1:
		speed_progress=1
	var game_speed=pow(MAX_GAME_SPEED,speed_progress)
	update_speed_of_objects(game_speed)

func update_speed_of_objects(factor: float):
	%Player.update_speed(factor)
	%Balls.update_speed(factor)

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
