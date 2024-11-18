extends Node2D

	
func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		$TextureFace.visible = false
	

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		$TextureFace.visible = true
