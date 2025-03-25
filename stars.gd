extends Node2D

const MAX_STARS:=100

func _ready():
	add_random_stars(MAX_STARS)
	skip_time(30)

func skip_time(time: float):
	const FPS=60
	var frames:=int(floor(time*FPS))
	for frame in range(frames):
		var delta=1.0/FPS
		_process(delta)
		for star in get_children():
			star._process(delta)

func _process(_delta: float) -> void:
	var star_count=get_child_count()
	if star_count<MAX_STARS:
		add_random_stars(MAX_STARS-star_count)

func get_random_position_for_star():
	const OFFSET_MIN=50
	const OFFSET_MAX=2000
	var viewport=get_viewport().size
	var minp=Vector2(viewport.x+OFFSET_MIN,0)
	var maxp=Vector2(viewport.x+OFFSET_MAX,viewport.y)
	return Vector2(randf_range(minp.x,maxp.x),randf_range(minp.y,maxp.y))

func add_random_stars(count):
	for i in range(count):
		add_random_star()

func add_random_star():
	var star=preload("res://star.tscn").instantiate()
	
	star.global_position=get_random_position_for_star()
	star.speed=randf_range(20,100)
	
	add_child(star)
