extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		if self.name == "DeathTriger":
			DeathTriger(body)
		if self.name == "PoolTriger":
			PoolTriger(body)
		

func DeathTriger(body):
	body.hpComponent.take_damage()

func PoolTriger(body):
	body.player_body_state = 0
