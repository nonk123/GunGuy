extends KinematicBody2D


const PIXELS_PER_METER = 32

const GRAVITY = 9.8

const MOVEMENT_SPEED = 5.0

const JUMP_POWER = 8.0

var velocity = Vector2.ZERO

onready var body = $Body

onready var flip_offset = body.offset.x


func _physics_process(delta):
	velocity.y += PIXELS_PER_METER * GRAVITY * delta
	
	var direction = 0.0
	
	direction += Input.get_action_strength("right")
	direction -= Input.get_action_strength("left")
	
	velocity.x = PIXELS_PER_METER * MOVEMENT_SPEED * direction
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = -PIXELS_PER_METER * JUMP_POWER
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _process(_delta):
	var anim_player = $AnimationPlayer
	
	if velocity.x > 0.0:
		body.flip_h = false
		body.offset.x = flip_offset
	elif velocity.x < 0.0:
		body.flip_h = true
		body.offset.x = -flip_offset
	
	if velocity.x == 0.0:
		anim_player.stop()
	else:
		anim_player.play("gait")
