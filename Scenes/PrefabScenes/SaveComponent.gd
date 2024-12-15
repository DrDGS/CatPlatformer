extends Node2D

var coordinate = Vector2(-11, -26.01094)
var state = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func savePoint():
	coordinate = get_parent().get_position()
	state = get_parent().player_body_state

func loadPoint():
	get_parent().set_position(coordinate)
	get_parent().player_body_state = state
	get_parent().hpComponent.setMaxHp()
	var all_childs = get_parent().get_parent().get_children()
	for child in all_childs:
		if child.name.begins_with("TextTriger") and child.after_death:
			child.can_show = true
	
