extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func triger():
	print(1)


func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		body.hpComponent.take_damage()
