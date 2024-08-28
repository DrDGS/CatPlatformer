extends Node2D

var direction
var is_walk
var is_run
var is_jump
var is_climping

# Input handler 
func _physics_process(delta):
	direction = Input.get_axis("move_left", "move_right")
