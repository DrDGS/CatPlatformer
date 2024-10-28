extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		$TextureFace.visible = false
	#var texture = $Texture.get_texture()
	#var image = texture.get_image()
	#RenderingServer.texture_2d_update(texture, image, $TextureFace.z_index)
	

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		$TextureFace.visible = true
	#var texture = $Texture.get_texture()
	#var image = texture.get_image()
	#RenderingServer.texture_2d_update(texture, image, $TextureFace.z_index)
