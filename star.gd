extends Node2D

var speed:=0.0

func _process(delta: float) -> void:
	global_position.x-=speed*delta
	if global_position.x<-50:
		queue_free()
