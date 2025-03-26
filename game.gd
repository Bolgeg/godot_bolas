extends Node2D

signal game_over(score)

func _process(_delta: float) -> void:
	%LivesLabel.text=str(%Player.lives)
	%ScoreLabel.text=str(%Player.score)
	if %Player.lives<=0:
		%Player.lives=0
		game_over.emit(%Player.score)
		pause()

func pause():
	process_mode=Node.PROCESS_MODE_DISABLED

func destroy():
	queue_free()
