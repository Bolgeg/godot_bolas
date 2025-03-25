extends Node2D

func _process(_delta: float) -> void:
	%LivesLabel.text=str(%Player.lives)
	%ScoreLabel.text=str(%Player.score)
