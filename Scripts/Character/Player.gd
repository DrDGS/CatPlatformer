extends CharacterBody2D

# SPEED - walking speed value
# VEL_RUN_COEF - multiplies SPEED to get running speed
# ACCELERATION - delta for reaching speed
# AC_STOP_COEF - multiplies ACCELERATION to get delta for dropping speed

@export var SPEED = 100.0
@export var VEL_RUN_COEF = 3
@export var ACCELERATION = 30
@export var AC_STOP_COEF = 1.25

# Relating to JUMP Mechanic
# JUMP_HEIGHT - height of peak
# TIME_ASCEND - reaching peak time
# TIME_DESCEND - falling on floor time
# JUMP_VELOCITY - self-explanatory name
# GRAVITY_ASC - gravity while ascending (~980 - approx project var)
# GRAVITY_DSC - gravity while descending

@export var JUMP_HEIGHT = -80
@export var TIME_ASCEND = 0.4
@export var TIME_DESCEND = 0.5

@onready var JUMP_VELOCITY = (2 * JUMP_HEIGHT) / (TIME_ASCEND)
@onready var GRAVITY_ASC = (-2 * JUMP_HEIGHT) / (TIME_ASCEND * TIME_ASCEND)
@onready var GRAVITY_DSC = (-2 * JUMP_HEIGHT) / (TIME_DESCEND * TIME_DESCEND)


@export var WALL_CLIMBING_VELOCITY = 25
@export var WALL_KNOKBACK = 200


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
	print("Player state: ", State.keys()[player_state])
	move_and_slide()


func apply_gravity(delta):
	velocity.y += get_gravity() * delta
	print("Gravity: ", get_gravity())
	

func get_gravity():
	return GRAVITY_ASC if velocity.y < 0.0 else GRAVITY_DSC


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
		
	if plInput.is_jump and is_on_floor():
		player_state = State.Jump


func player_walk():
	velocity.x = move_toward(velocity.x, plInput.direction * SPEED, ACCELERATION)
	if not plInput.direction:
		player_state = State.Idle
	if plInput.direction and plInput.is_run:
		player_state = State.Run
	if plInput.is_jump and is_on_floor():
		player_state = State.Jump


func player_run():
	velocity.x = move_toward(velocity.x, plInput.direction * SPEED * VEL_RUN_COEF,
			 ACCELERATION)
	if not plInput.direction:
		player_state = State.Idle
	if  not plInput.is_run:
		player_state = State.Walk
	if plInput.is_jump and is_on_floor():
		player_state = State.Jump
		

func player_jump():
	if plInput.in_air:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		player_state = State.Jump
		
	print("Vertical velocity: ", velocity.y)

	if plInput.in_air:
		# jump without collisions
		if velocity.y >= GRAVITY_DSC * TIME_ASCEND * 0.1:
			plInput.in_air = false
		#if get_last_slide_collision():
			#plInput.in_air = false

	if not plInput.in_air and is_on_floor():
		if not plInput.direction:
			player_state = State.Idle
		elif plInput.direction and not plInput.is_run:
			player_state = State.Walk
		elif plInput.direction and plInput.is_run:
			player_state = State.Run


func jump_animation_finished():
	player_state = State.Idle


func _process(_delta):
	animation_logic(Vector2(plInput.direction, 0))
	player_animation()
	if (Input.is_action_just_pressed("TestTakeDamage")):
		hpComponent.take_damage(1);


func animation_logic(direction : Vector2):
	animation_tree["parameters/blend_position"] = direction.normalized();
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0


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

