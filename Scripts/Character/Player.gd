extends CharacterBody2D

# SPEED - walking speed value
# VEL_RUN_COEF - multiplies SPEED to get running speed
# ACCELERATION - delta for reaching speed
# AC_STOP_COEF - multiplies ACCELERATION to get delta for dropping speed
# JUMP_VELOCITY - vertical speed

@export var SPEED = 100.0
@export var VEL_RUN_COEF = 3
@export var ACCELERATION = 30
@export var AC_STOP_COEF = 1.25
@export var JUMP_VELOCITY = -400.0
@export var WALL_ClIMBING_VELOCITY = 25
@export var WALL_KNOKBACK = 200
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var hpComponent : Node2D
@export var plInput : Node2D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree

enum State {Idle, Walk, Run, Jump, Landing}
var player_state


func _ready():
	player_state = State.Idle


func _physics_process(delta):
	apply_gravity(delta)
	state_machine()
	print("Player_state: ", State.keys()[player_state])

	move_and_slide()


func apply_gravity(delta):
	if not (is_on_floor() or is_on_wall()):
		velocity.y += gravity * delta 


func state_machine():
	match player_state:
		State.Idle:
			player_idle()
			
		State.Walk:
			player_walk()
			
		State.Run:
			player_run()
			
		State.Jump:
			player_jump()


func player_idle():
	velocity.x = move_toward(velocity.x, 0, AC_STOP_COEF * ACCELERATION)
	
	if plInput.direction:
		player_state = State.Walk
		
	if plInput.direction and plInput.is_run:
		player_state = State.Run
		
	if plInput.is_jump:
		player_state = State.Jump


func player_walk():
	velocity.x = move_toward(velocity.x, plInput.direction * SPEED, ACCELERATION)
	if not plInput.direction:
		player_state = State.Idle
	if plInput.direction and plInput.is_run:
		player_state = State.Run
	if plInput.is_jump:
		player_state = State.Jump


func player_run():
	velocity.x = move_toward(velocity.x, plInput.direction * SPEED * VEL_RUN_COEF,
			 ACCELERATION)
	if not plInput.direction:
		player_state = State.Idle
	if  not plInput.is_run:
		player_state = State.Walk
	if plInput.is_jump:
		player_state = State.Jump
		
		
func player_jump():
	velocity.y = JUMP_VELOCITY

	if is_on_floor() and not plInput.direction:
		player_state = State.Idle
	if is_on_floor() and plInput.direction and not plInput.is_run:
		player_state = State.Walk
	if is_on_floor() and plInput.direction and plInput.is_run:
		player_state = State.Run


func player_animation():
	match player_state:
		State.Idle:
			animation_player.play("CatIdle")
		State.Walk:
			animation_player.play("CatWalk")
		State.Run:
			animation_player.play("CatWalk")
		State.Jump:
			animation_player.play("CatJump")


func animation_logic(direction : Vector2):
	animation_tree["parameters/blend_position"] = direction.normalized();
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0


func _process(_delta):
	animation_logic(Vector2(plInput.direction, 0))
	player_animation()
	if (Input.is_action_just_pressed("TestTakeDamage")):
		hpComponent.take_damage(1);


	#player_falling(delta)
	#player_idle()
	## Move
	#player_walk(direction)
	#if Input.is_action_pressed("run"):
		#player_run(direction)
	#
	#player_jump(direction)
##	player_climbing(delta)
#
	#print("State: ", State.keys()[current_state], " direction: ", direction)
	#player_animation()
	#
#
	#if is_on_wall() and not is_on_floor():
		#is_wall_climbing = Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")
	#else:
		#is_wall_climbing = false
	#if is_wall_climbing:
		#var collision = get_slide_collision(0)
		#var body = collision.get_collider()
		#var wall_type = body.get_layer_for_body_rid(collision.get_collider_rid())
		#if wall_type == 0:
			#velocity.y += (WALL_ClIMBING_VELOCITY * delta)
			#velocity.y = min(velocity.y, WALL_ClIMBING_VELOCITY)
		#else:
			#velocity.y = min(velocity.y, 0)
			

#func player_climbing(delta):
	#if is_on_wall() and not is_on_floor():
		#if (Input.is_action_pressed("move_right") 
				#or Input.is_action_pressed("move_left")) :
			#current_state = State.Climbing
		#else:
			#current_state = State.Idle
			#
	#if current_state == State.Climbing:
		#var collision = get_slide_collision(0)
		#var body = collision.get_collider()
		#var wall_type = body.get_layer_for_body_rid(collision.get_collider_rid())
		#if wall_type == 0:
			#velocity.y += (WALL_ClIMBING_VELOCITY * delta)
			#velocity.y = min(velocity.y, WALL_ClIMBING_VELOCITY)
		#else:
			#velocity.y = min(velocity.y, 0)

