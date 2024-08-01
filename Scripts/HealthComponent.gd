extends Node2D

@export var maxHP = 10
var currentHP


func _ready():
	currentHP = maxHP


func takeDamage(damage):
	currentHP -= damage
	
	if (currentHP <= 0):
		get_parent().get_child(0).queue_free() #testing result
