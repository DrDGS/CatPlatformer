extends CharacterBody2D


@export var SPEED = 300.0
@export var ACCELERATION = 30
@export var JUMP_VELOCITY = -400.0
@export var WALL_ClIMBING_VELOCITY = 25
@export var WALL_KNOKBACK = 200
var is_wall_climbing = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var hpComponent : Node2D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree

enum State {Idle, Walk, Run, Jump, Climbing}
var current_state


func _ready():
	current_state = State.Idle

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	player_falling(delta)
	player_idle()
	# Move
	player_walk(direction)
	if Input.is_action_pressed("run"):
		player_run(direction)
	
	player_jump(direction)
#	player_climbing(delta)

	print("State: ", State.keys()[current_state], " direction: ", direction)
	player_animation()
	

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
	player_animation()


func player_falling(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func player_idle():
	if is_on_floor():
		current_state = State.Idle


func player_walk(direction):
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED / 3, ACCELERATION / 5)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	if is_on_floor() and direction != 0:
		current_state = State.Walk


func player_run(direction):
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	if is_on_floor() and direction != 0:
		current_state = State.Run


func player_jump(direction):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		elif is_on_wall():	# ВОЛЛ-ДЖАМП
			if Input.is_action_pressed("move_right"):
				velocity.y = JUMP_VELOCITY
				if Input.is_action_just_pressed("run"):
					velocity.x = -WALL_KNOKBACK * 2 
				else:
					velocity.x = -WALL_KNOKBACK * 1
					
			elif Input.is_action_pressed("move_left"):
				velocity.y = JUMP_VELOCITY
				if Input.is_action_just_pressed("run"):
					velocity.x = WALL_KNOKBACK * 2 
				else:
					velocity.x = WALL_KNOKBACK * 1

		current_state = State.Jump
		
	if not is_on_floor() and current_state == State.Jump:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION / 10)


func player_climbing(delta):
	if is_on_wall() and not is_on_floor():
		if (Input.is_action_pressed("move_right") 
				or Input.is_action_pressed("move_left")) :
			current_state = State.Climbing
		else:
			current_state = State.Idle
			
	if current_state == State.Climbing:
		var collision = get_slide_collision(0)
		var body = collision.get_collider()
		var wall_type = body.get_layer_for_body_rid(collision.get_collider_rid())
		if wall_type == 0:
			velocity.y += (WALL_ClIMBING_VELOCITY * delta)
			velocity.y = min(velocity.y, WALL_ClIMBING_VELOCITY)
		else:
			velocity.y = min(velocity.y, 0)

func player_animation():
	match current_state:
		State.Idle:
			animation_player.play("CatIdle")
		State.Walk:
			animation_player.play("CatWalk")
		State.Run:
			animation_player.play("CatWalk")
			animation_player.set_speed_scale(1.5)
		State.Jump:
			animation_player.play("CatJump")


func animation_logic(direction : Vector2):
	animation_tree["parameters/blend_position"] = direction.normalized();
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0


func _process(delta):
	if (Input.is_action_just_pressed("TestTakeDamage")):
		hpComponent.take_damage(1);
