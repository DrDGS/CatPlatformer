extends CharacterBody2D

# SPEED - walking speed value
# VEL_RUN_COEF - multiplies SPEED to get running speed
# ACCELERATION - delta for reaching speed
# AC_STOP_COEF - multiplies ACCELERATION to get delta for dropping speed

@export var SPEED = 96.0
@export var VEL_RUN_COEF = 1.5
@export var ACCELERATION = 30
@export var AC_STOP_COEF = 1.25

@export var DRY_SPEED_COEF = 1
@export var WET_SPEED_COEF = 0.5
@export var ELEC_SPEED_COEF = 1.5

@export var DRY_JUMP_COEF = 1
@export var WET_JUMP_COEF = 0.5
@export var ELEC_JUMP_COEF = 1.5

# Relating to JUMP Mechanic
# JUMP_HEIGHT - height of peak
# TIME_ASCEND - reaching peak time
# TIME_DESCEND - falling on floor time
# JUMP_VELOCITY - self-explanatory name
# GRAVITY_ASC - gravity while ascending (~980 - approx project var)
# GRAVITY_DSC - gravity while descending

@export var JUMP_HEIGHT = -84
@export var JUMP_HEIGHT_BASE = -84
@export var JUMP_HEIGHT_FACTOR_FROM_X = 0.1
@export var TIME_ASCEND = 0.4
@export var TIME_DESCEND = 0.5
@export var TIME_ASCEND_BASE = 0.4
@export var TIME_DESCEND_BASE = 0.5
@export var ANIMATION_GROUND_TIME = 0.8

@onready var JUMP_VELOCITY = (2 * JUMP_HEIGHT) / (TIME_ASCEND)
@onready var GRAVITY_ASC = -(2 * JUMP_HEIGHT) / (TIME_ASCEND * TIME_ASCEND)
@onready var GRAVITY_DSC = -(2 * JUMP_HEIGHT) / (TIME_DESCEND * TIME_DESCEND)

@export var WALL_CLIMBING_VELOCITY = 25
@export var WALL_KNOKBACK = 200
@export var TIME_TO_IDLE = 1.05

@export var hpComponent : Node2D
@export var plInput : Node2D
@export var saveComponent : Node2D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var idle_timer = $IdleTimer
@onready var jump_timer = $JumpTimer

enum State {Idle, Walk, Run, Jump, Landing, OnWall, OnWallIdle}
enum BodyState {Wet, Dry, Elec}
var player_state
var player_body_state
var was_running
var speed_coef
var jump_coef
var animation_ground

func _ready():
	player_state = State.Idle
	player_body_state = BodyState.Dry
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	jump_timer.timeout.connect(_on_jump_timer_timeout)


func _physics_process(delta):
	apply_gravity(delta)
	state_machine()
	#print("Player state: ", State.keys()[player_state])
	move_and_slide()


func apply_gravity(delta):
	velocity.y += get_gravity() * delta
	

func get_gravity():
	return GRAVITY_ASC if velocity.y < 0.0 else GRAVITY_DSC

func calculate_gravity():
	JUMP_HEIGHT = JUMP_HEIGHT_BASE * jump_coef
	TIME_ASCEND = TIME_ASCEND_BASE * jump_coef
	TIME_DESCEND = TIME_DESCEND_BASE * jump_coef
	JUMP_VELOCITY = (2 * JUMP_HEIGHT) / (TIME_ASCEND)
	GRAVITY_ASC = -(2 * JUMP_HEIGHT) / (TIME_ASCEND * TIME_ASCEND)
	GRAVITY_DSC = -(2 * JUMP_HEIGHT) / (TIME_DESCEND * TIME_DESCEND)


func state_machine():
	match player_body_state:
		BodyState.Dry:
			speed_coef = DRY_SPEED_COEF
			jump_coef = DRY_JUMP_COEF
			calculate_gravity()
		BodyState.Wet:
			speed_coef = WET_SPEED_COEF
			jump_coef = WET_JUMP_COEF
			calculate_gravity()
		BodyState.Elec:
			speed_coef = ELEC_SPEED_COEF
			jump_coef = ELEC_JUMP_COEF
			calculate_gravity()
	match player_state:
		State.Idle:
			player_idle()
			
		State.Walk:
			player_walk()
			
		State.Run:
			player_run()
			
		State.Jump:
			player_jump()
		
		State.OnWall:
			player_onWall()
		State.OnWallIdle:
			player_onWall()


func player_idle():
	was_running = false
	velocity.x = move_toward(velocity.x, 0, AC_STOP_COEF * ACCELERATION)
	
	if plInput.direction:
		player_state = State.Walk
		
	if plInput.direction and plInput.is_run:
		player_state = State.Run
		
	if plInput.is_jump and is_on_floor():
		player_state = State.Jump


func player_walk():
	was_running = false
	velocity.x = move_toward(velocity.x, plInput.direction * SPEED * speed_coef, ACCELERATION)
	
	if not plInput.direction:
		player_state = State.Idle
	if plInput.direction and plInput.is_run:
		player_state = State.Run
	if plInput.is_jump and is_on_floor():
		player_state = State.Jump


func player_run():
	was_running = true
	velocity.x = move_toward(velocity.x, plInput.direction * SPEED * VEL_RUN_COEF * speed_coef,
			 ACCELERATION)
	
	if not plInput.direction:
		player_state = State.Idle
	if  not plInput.is_run:
		player_state = State.Walk
	if plInput.is_jump and is_on_floor():
		player_state = State.Jump
		

func player_jump():
	if not is_on_wall():
		plInput.can_climb_wall = true
	if plInput.in_air:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY - (abs(velocity.x) * JUMP_HEIGHT_FACTOR_FROM_X)
		player_state = State.Jump

	if plInput.in_air:
		# jump without collisions
		if velocity.y >= GRAVITY_DSC * TIME_ASCEND * 0.1:
			plInput.in_air = false

	if not plInput.in_air and is_on_floor():
		if not plInput.direction:
			player_state = State.Idle
		elif plInput.direction and not plInput.is_run:
			player_state = State.Walk
		elif plInput.direction and plInput.is_run:
			player_state = State.Run
	
	if is_on_wall() and plInput.direction and plInput.can_climb_wall:
		idle_timer.wait_time = TIME_TO_IDLE
		idle_timer.start()
		player_state = State.OnWall


func player_onWall():
	if is_on_wall() and not is_on_floor() and plInput.direction:
		plInput.can_climb_wall = false
		velocity.x = plInput.direction * SPEED
		var collision = get_slide_collision(0)
		var body = collision.get_collider()
		var wall_type = body.get_layer_for_body_rid(collision.get_collider_rid())
		if wall_type == 0:
			velocity.y += (WALL_CLIMBING_VELOCITY)
			velocity.y = min(velocity.y, WALL_CLIMBING_VELOCITY)
		else:
			velocity.y = min(velocity.y, 0)	
	else:
		player_state = State.Jump
	if plInput.is_jump:
		idle_timer.stop()
		flip_h(Vector2(-plInput.direction, 0))
		velocity.y = JUMP_VELOCITY
		velocity.x = (get_wall_normal().x) * WALL_KNOKBACK * (2 if was_running else 1) * speed_coef
		player_state = State.Jump


func _on_idle_timer_timeout():
	player_state = State.OnWallIdle
	was_running = false
	idle_timer.stop()

func _on_jump_timer_timeout():
	animation_ground = true
	jump_timer.stop()


func _process(_delta):
	animation_logic(Vector2(plInput.direction, 0))
	player_animation()
	if (Input.is_action_just_pressed("TestAddSavePoint")):
		saveComponent.savePoint()
	if (Input.is_action_just_pressed("TestLoadFromSavePoint")):
		saveComponent.loadPoint()
	if (Input.is_action_just_pressed("TestTakeDamage")):
		hpComponent.take_damage(1);
	if (Input.is_action_just_pressed("TestDryState")):
		player_body_state = BodyState.Dry
	if (Input.is_action_just_pressed("TestWetState")):
		player_body_state = BodyState.Wet
	if (Input.is_action_just_pressed("TestElecState")):
		player_body_state = BodyState.Elec


func animation_logic(direction : Vector2):
	animation_tree["parameters/blend_position"] = direction.normalized();
	if direction.x != 0 and (player_state == State.Walk or player_state == State.Idle or player_state == State.Run or player_state == State.OnWall):
		flip_h(direction)


func flip_h(direction : Vector2):
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
			if plInput.in_air:
				if animation_player.current_animation != "CatJumpUpFinish":
					jump_timer.wait_time = TIME_ASCEND + TIME_DESCEND - ANIMATION_GROUND_TIME
					jump_timer.start()
					animation_ground = false
					animation_player.play("CatJumpUp")
				animation_player.queue("CatJumpUpFinish")
			else:
				if animation_ground:
					animation_player.play("CatJumpDownFinish")
				else:
					animation_player.play("CatJumpDown")
		State.OnWall:
			animation_player.play("CatOnWall")
		State.OnWallIdle:
			animation_player.play("CatOnWallIdle")


