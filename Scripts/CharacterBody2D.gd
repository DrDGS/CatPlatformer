extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_ClIMBING_VELOCITY = 25
const WALL_KNOKBACK = 800

var is_wall_climbing = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var hpComponent : Node2D
@onready var animTree = $AnimationTree

func _ready():
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall() and Input.is_action_pressed("ui_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = WALL_KNOKBACK
			
		elif is_on_wall() and Input.is_action_pressed("ui_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_KNOKBACK
	
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			is_wall_climbing = true
		else:
			is_wall_climbing = false
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
