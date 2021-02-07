extends KinematicBody2D


const ROTATION_SPEED = 10.0

var direction = Vector2.ZERO

onready var sprite = $Sprite


func _physics_process(_delta):
	var collision = move_and_collide(direction)
	
	if collision:
		queue_free()


func _process(delta):
	var rad_per_sec = TAU * ROTATION_SPEED / direction.length()
	sprite.rotate(delta * rad_per_sec)
