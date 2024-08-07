@tool extends Camera2D

@export_category("Follow Character")
@export var targetObject : Node2D

@export_category("Camera Movement")
@export var smoothing_enabled : bool = false:
	set(value):
		if value == smoothing_enabled : return
		smoothing_enabled = value
		notify_property_list_changed()

var time_offset : float = 1.0
var smoothing_distance : int = 8

@onready var time_left : float = time_offset

func _physics_process(delta):
	if targetObject != null:
		var camera_position : Vector2
		
		if smoothing_enabled:
			if (is_equal_approx(global_position.length(), targetObject.global_position.length())):
				time_left = time_offset
			elif (time_left > 0):
				time_left -= delta
			if (time_left <= 0):
				var weight : float = float(smoothing_distance) / 100
				camera_position = lerp(global_position, targetObject.global_position, weight)
		else:
			camera_position = targetObject.global_position
		global_position = camera_position

func _get_property_list():
	if Engine.is_editor_hint():
		var ret = []
		if smoothing_enabled:
			ret.append({
				"name": &"smoothing_distance",
				"type": TYPE_INT,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint_string": "1,100",
				"hint": PROPERTY_HINT_RANGE
			})
			ret.append({
				"name": &"time_offset",
				"type": TYPE_FLOAT,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint_string": "0, 100",
				"hint": PROPERTY_HINT_RANGE
			})
		return ret
