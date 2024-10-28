extends Camera2D

@export_category("Follow Character")
@export var targetObject : Node2D

@export_category("Camera Movement")
@export var smoothing_enabled : bool = false
@export_range(1, 100) var smoothing_distance : int = 8
@export var ignored_distance : float = 30


var camera_position : Vector2
var target_position : Vector2

func _ready():
	global_position = targetObject.global_position
	camera_position = global_position

func _physics_process(delta):
	if targetObject != null:
		var distance = (global_position - targetObject.global_position).length()
		
		if smoothing_enabled:
			if (distance > ignored_distance):
				target_position = targetObject.global_position
				
			var weight : float = float(smoothing_distance) / 100
			camera_position = lerp(global_position, target_position, weight)
			
		elif not smoothing_enabled:
			target_position = targetObject.global_position
			camera_position = target_position
			
		global_position = camera_position
