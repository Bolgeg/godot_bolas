extends Node2D

func _on_start_button_pressed() -> void:
	exit_menu()
	enter_game()

func _on_game_over(score):
	%GameOverMenu.visible=true
	%GameOverMenu.start(score)

func _on_menu_button_pressed() -> void:
	exit_game()
	enter_menu()

func _on_restart_button_pressed() -> void:
	exit_game()
	enter_game()

func exit_menu():
	%MainMenu.visible=false
func enter_menu():
	%MainMenu.visible=true
func exit_game():
	for child in %GameContainer.get_children():
		if child.has_method("destroy"):
			child.destroy()
	if %GameOverMenu.visible:
		%GameOverMenu.visible=false
func enter_game():
	var game=preload("res://game.tscn").instantiate()
	game.game_over.connect(_on_game_over)
	%GameContainer.add_child(game)
