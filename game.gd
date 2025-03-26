extends Node2D

signal game_over(score)

var lost:=false
var paused:=false
var game_time:=0.0

const GAME_SPEED_FACTOR_SLOW:=0.25
const GAME_SPEED_FACTOR_NORMAL:=1.0
var game_speed_factor:=GAME_SPEED_FACTOR_NORMAL

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
		game_time+=delta*game_speed_factor
		update_game_speed()
		update_game_progress()

func update_game_speed():
	const MAX_GAME_SPEED:=10.0
	const MAX_GAME_TIME_FOR_SPEED:=300.0
	var speed_progress=game_time/MAX_GAME_TIME_FOR_SPEED
	if speed_progress>1:
		speed_progress=1
	var game_speed=pow(MAX_GAME_SPEED,speed_progress)
	update_speed_of_objects(game_speed)

func update_game_progress():
	const GAME_PROGRESS_PER_SECOND:=1/30.0
	var game_progress=game_time*GAME_PROGRESS_PER_SECOND
	%Balls.update_game_progress(game_progress)

func update_speed_of_objects(factor: float):
	%Player.update_speed(factor*game_speed_factor)
	%Balls.update_speed(factor*game_speed_factor)

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


func _on_player_game_slow_down_triggered() -> void:
	if %SlowDownTimer.is_stopped():
		%SfxSlowdown.play()
	else:
		%SfxSlowdownRecatch.play()
	%SlowDownTimer.start()
	game_speed_factor=GAME_SPEED_FACTOR_SLOW

func _on_slow_down_timer_timeout() -> void:
	game_speed_factor=GAME_SPEED_FACTOR_NORMAL
