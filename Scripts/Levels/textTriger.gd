extends Area2D

@export var text = ""
@export var bottomUI: Label
@export var has_entered = false
@export var can_show = true
@export var time_out = 5
@export var show_time = 5
@export var after_death = false

@onready var timer = $Timer
var show = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	if show:
		show = false
		bottomUI.text = ""
	else:
		can_show = true
	timer.stop()


func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		if can_show and has_entered:
			bottomUI.text = text
			show = true
			timer.wait_time = show_time
			timer.start()
		
	


func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		if has_entered:
			bottomUI.text = ""
			can_show = false
			show = false
			if timer.is_stopped() and not after_death:
				timer.wait_time = time_out
				timer.start()
		else:
			has_entered = true
