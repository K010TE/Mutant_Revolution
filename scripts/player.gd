extends CharacterBody2D

var state_machine
var is_dead: bool = false

@export_category("Variables")
@export var move_speed: float = 256.0
@export var acceleration: float = 0.4
@export var friction: float = 0.8
@export var dash_speed: float = 1024.0
@export var dash_time: float = 0.4
@export var dash_cooldown: float = 1.0

@export_category("Objects")
@export var animation_tree: AnimationTree = null


var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true
	state_machine = animation_tree["parameters/playback"]

func _physics_process(delta):
	if is_dead:
		return
	
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		dash()
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		velocity = dash_direction * dash_speed
		
	move()
	animate()
	move_and_slide()

func move():
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if direction != Vector2.ZERO:
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
		animation_tree["parameters/dash/blend_position"] = direction
		#animation_tree["parameters/atk/blend_position"] = direction
		
		velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, acceleration)
		velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, acceleration)
		return
		
	velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, friction)
	velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, friction)

func dash():
	is_dashing = true
	dash_timer = dash_time
	dash_cooldown_timer = dash_cooldown
	dash_direction = velocity.normalized()
	velocity = dash_direction * dash_speed

func animate():
	if is_dashing:
		state_machine.travel("dash")
		return
		
	if velocity.length() > 5:
		state_machine.travel("walk")
		return
		
	state_machine.travel("idle")
	
