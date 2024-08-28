extends Node2D

var Health_point = 9

func take_damage(value = 1):
	Health_point -= value
	print("Curent health: ", Health_point)
	if Health_point == 0:
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
