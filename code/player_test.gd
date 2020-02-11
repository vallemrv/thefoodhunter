extends KinematicBody2D


var gravity = 2000
var velocity = Vector2()

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity)

