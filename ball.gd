extends CharacterBody2D

const BALL_LIMIT_MIN_X:=-200.0

const BALL_TYPES:=[
	"red",
	"green",
	"blue",
	"yellow",
	"gray",
]
const BALL_COLORS:={
	"red":Color(1,0,0,1),
	"green":Color(0,1,0,1),
	"blue":Color(0,0,1,1),
	"yellow":Color(1,1,0,1),
	"gray":Color(0.5,0.5,0.5,1),
}
const BALL_MAGNET_ATTRACTION:={
	"red":-1,
	"green":1,
	"blue":1,
	"yellow":0,
	"gray":0,
}

const INITIAL_SPEED:=500.0
var speed:=INITIAL_SPEED

var relative_velocity:=Vector2(0,0)

var type:=BALL_TYPES[0]

func _physics_process(_delta: float) -> void:
	velocity=Vector2(-speed,0)+relative_velocity
	move_and_slide()
	
	var bodies=%Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("ball_collision"):
			body.ball_collision(type)
	if bodies.size()>0:
		queue_free()
	
	if global_position.x<BALL_LIMIT_MIN_X:
		queue_free()

func update_speed(factor: float):
	speed=INITIAL_SPEED*factor

func update_magnet_effect(delta: float,player_position: Vector2,game_speed: float):
	const MAGNET_ACCELERATION:=100000000.0
	const MAGNET_EFFECT_MAX_DISTANCE:=1000.0
	
	var distance=global_position.distance_to(player_position)
	if distance<=MAGNET_EFFECT_MAX_DISTANCE:
		var direction=(player_position-global_position).normalized()*BALL_MAGNET_ATTRACTION[type]
		var acceleration=direction*MAGNET_ACCELERATION*game_speed/(distance*distance)
		relative_velocity+=acceleration*delta
		
		var relative_velocity_x_limit=speed*0.9
		if relative_velocity.x>relative_velocity_x_limit:
			relative_velocity.x=relative_velocity_x_limit

func set_type(newType: String):
	if newType in BALL_TYPES:
		type=newType
		%Sprite2D.modulate=BALL_COLORS[type]
