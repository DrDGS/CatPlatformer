extends Camera2D

@export var targetObject : Node2D
@export var maxOffset : float
@export var snapping : float

func _process(delta):
	position = targetObject.position
