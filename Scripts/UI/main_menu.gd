extends CanvasLayer



func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/testing_scene.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/oprions.tscn")


func _on_exit_pressed():
	get_tree().quit()
