extends CharacterBody2D


@export var SPEED = 300.0
@export var ACCELERATION = 30
@export var JUMP_VELOCITY = -400.0
@export var WALL_ClIMBING_VELOCITY = 25
@export var WALL_KNOKBACK = 200
var is_wall_climbing = false
var is_run = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var hpComponent : Node2D
@onready var animTree = $AnimationTree

func _ready():
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor() or is_on_wall():
		if Input.is_action_pressed("run"):
			if is_on_floor():
				is_run = true
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
		else:
			if is_on_floor():
				is_run = false
			velocity.x = move_toward(velocity.x, direction * SPEED / 3, ACCELERATION * 3)
	else:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION / 10)
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			if Input.is_action_pressed("ui_right"):
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_KNOKBACK * (2 if is_run else 1)
			elif Input.is_action_pressed("ui_left"):
				velocity.y = JUMP_VELOCITY
				velocity.x = WALL_KNOKBACK * (2 if is_run else 1)
			
	
	if is_on_wall() and not is_on_floor():
		is_wall_climbing = Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")
	else:
		is_wall_climbing = false
	if is_wall_climbing:
		var collision = get_slide_collision(0)
		var body = collision.get_collider()
		var wall_type = body.get_layer_for_body_rid(collision.get_collider_rid())
		if wall_type == 0:
			velocity.y += (WALL_ClIMBING_VELOCITY * delta)
			velocity.y = min(velocity.y, WALL_ClIMBING_VELOCITY)
		else:
			velocity.y = min(velocity.y, 0)	
			
	animation_logic(Vector2(direction, 0))
	move_and_slide()


func animation_logic(direction : Vector2):
	animTree["parameters/blend_position"] = direction.normalized();
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0


func _process(delta):
	if (Input.is_action_just_pressed("TestTakeDamage")):
		hpComponent.takeDamage(1);
