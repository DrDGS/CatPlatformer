extends Node2D

var direction
var is_run
var is_jump
var in_air
var can_climb_wall
var change_body_state

# Input handler 
# List of actions
# 1. Lateral movement
# 2. Sprint
# 3. Jump

func _physics_process(delta):
	direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("run"):
		is_run = true
	else:
		is_run = false
		
	if Input.is_action_pressed("ui_up"):
		change_body_state = true
	else:
		change_body_state = false

	if Input.is_action_just_pressed("jump"):
		is_jump = true
		in_air = true
	else:
		is_jump = false
