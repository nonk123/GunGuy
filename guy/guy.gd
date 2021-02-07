extends KinematicBody2D


const PIXELS_PER_METER = 32

const GRAVITY = 9.8

const MOVEMENT_SPEED = 5.0

const JUMP_POWER = 8.0

const BULLET_SPEED = 10.0

# The guy's RPM.
const FIRERATE = 600

var velocity = Vector2.ZERO

var shooting_direction = 1.0

var shooting_speed = 60.0 / FIRERATE

var shot_cooldown = shooting_speed

onready var world = get_node("/root/World")

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
	
	shot_cooldown += delta
	
	var ready_to_shoot = shot_cooldown >= shooting_speed
	
	if Input.is_action_pressed("shoot") and ready_to_shoot:
		shot_cooldown = 0.0
		shoot()


func _process(_delta):
	var anim_player = $AnimationPlayer
	
	if velocity.x > 0.0:
		body.flip_h = false
		body.offset.x = flip_offset
		shooting_direction = 1.0
	elif velocity.x < 0.0:
		body.flip_h = true
		body.offset.x = -flip_offset
		shooting_direction = -1.0
	
	if velocity.x == 0.0:
		anim_player.stop()
	else:
		anim_player.play("gait")


func shoot():
	var our_width = $Shape.shape.extents.x
	
	var bullet = preload("res://entities/bullet.tscn").instance()
	var bullet_width = bullet.get_node("Shape").shape.radius
	
	bullet.direction.x = shooting_direction * BULLET_SPEED
	
	bullet.position = position
	bullet.position.x += shooting_direction * (our_width + bullet_width)
	
	world.add_child(bullet)
