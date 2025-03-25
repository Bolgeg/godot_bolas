extends CharacterBody2D

var speed:=500.0

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
	elif ball_type=="green":
		get_life()
		get_points(10)
	elif ball_type=="blue":
		get_points(1)
