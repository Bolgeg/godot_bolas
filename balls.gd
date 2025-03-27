extends Node

const MAX_BALLS:=50

var game_progress:=0.0

func update_game_progress(progress: float):
	game_progress=progress

func get_ball_probabilities():
	var probabilities:={
		"red":0.4,
		"green":0.1,
		"blue":0.5,
		"yellow":0.0,
		"gray":0.0,
	}
	
	if game_progress>=1:
		probabilities["yellow"]+=(game_progress-1)*0.005
		if probabilities["yellow"]>0.01:
			probabilities["yellow"]=0.01
		probabilities["gray"]=probabilities["yellow"]
	
	var sum:=0.0
	for t in probabilities:
		sum+=probabilities[t]
	if sum>0:
		for t in probabilities:
			probabilities[t]/=sum
	return probabilities

func _ready():
	add_random_balls(MAX_BALLS)

func _physics_process(_delta: float) -> void:
	var ball_count=get_child_count()
	if ball_count<MAX_BALLS:
		add_random_balls(MAX_BALLS-ball_count)

func update_speed(factor: float):
	for ball in get_children():
		ball.update_speed(factor)

func update_magnet_effect(delta: float,player_position: Vector2,game_speed: float):
	for ball in get_children():
		ball.update_magnet_effect(delta,player_position,game_speed)

func get_random_ball_type():
	var ball_probabilities=get_ball_probabilities()
	var x=randf()
	var sum:=0.0
	for type in ball_probabilities:
		sum+=ball_probabilities[type]
		if x<sum:
			return type
	return ball_probabilities.keys().back()

func get_random_position_for_ball():
	const OFFSET_MIN=500
	const OFFSET_MAX=10000
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
