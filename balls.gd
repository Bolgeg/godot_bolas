extends Node

const MAX_BALLS:=50

const BALL_PROBABILITIES:={
	"red":0.4,
	"green":0.1,
	"blue":0.5,
}

func _ready():
	add_random_balls(MAX_BALLS)

func _physics_process(_delta: float) -> void:
	var ball_count=get_child_count()
	if ball_count<MAX_BALLS:
		add_random_balls(MAX_BALLS-ball_count)

func get_random_ball_type():
	var x=randf()
	var sum:=0.0
	for type in BALL_PROBABILITIES:
		sum+=BALL_PROBABILITIES[type]
		if x<sum:
			return type
	return BALL_PROBABILITIES.keys().back()

func get_random_position_for_ball():
	const OFFSET_MIN=500
	const OFFSET_MAX=5000
	const WALL_DISTANCE=50
	var viewport=get_viewport().size
	var minp=Vector2(viewport.x+OFFSET_MIN,WALL_DISTANCE)
	var maxp=Vector2(viewport.x+OFFSET_MAX,viewport.y-WALL_DISTANCE)
	return Vector2(randf_range(minp.x,maxp.x),randf_range(minp.y,maxp.y))

func add_random_balls(count):
	for i in range(count):
		add_random_ball()

func add_random_ball():
	var ball=preload("res://ball.tscn").instantiate()
	
	ball.set_type(get_random_ball_type())
	
	ball.global_position=get_random_position_for_ball()
	
	add_child(ball)
