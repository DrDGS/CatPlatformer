extends Node2D

var Health_point = 1

func setMaxHp():
	Health_point = 1

func take_damage(value = 1):
	Health_point -= value
	print("Curent health: ", Health_point)
	if Health_point == 0:
		get_parent().saveComponent.loadPoint()
