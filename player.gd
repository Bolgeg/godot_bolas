extends CharacterBody2D

signal game_slow_down_triggered
signal game_magnet_mode_triggered

const INITIAL_SPEED:=500.0
var speed:=INITIAL_SPEED

var lives:=10
var score:=0

func _physics_process(_delta: float) -> void:
	
	var damaged=not %DamageTimer.is_stopped()
	var color=Color(0,0,1,1)
	if damaged:
		color=Color(1,0,0,1)
	%Sprite2D.modulate=color
	
	var movement:=Input.get_axis("move_up","move_down")
	velocity.y=speed*movement
	move_and_slide()

func update_speed(factor: float):
	speed=INITIAL_SPEED*factor

func lose_life():
	%DamageTimer.start()
	lives-=1

func get_life():
	lives+=1

func get_points(count):
	score+=count

func ball_collision(ball_type):
	if ball_type=="red":
		lose_life()
		%SfxHurt.play()
	elif ball_type=="green":
		get_life()
		get_points(10)
		%SfxPickup.play()
	elif ball_type=="blue":
		get_points(1)
		%SfxPickup.play()
	elif ball_type=="yellow":
		game_slow_down_triggered.emit()
	elif ball_type=="gray":
		game_magnet_mode_triggered.emit()
