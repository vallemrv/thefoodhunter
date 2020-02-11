extends KinematicBody2D

export (float) var grabity = 2500
export (float) var speed = 500
export (float) var jump_force = 1000

var velocity = Vector2()
var view_player = null
var state_machine
var double_jump = false

func _ready():
	view_player = get_node("view_player")
	$AnimationTree.active = true
	state_machine = $AnimationTree.get("parameters/playback")
	

func _input(event):
	var jump = Input.is_action_just_pressed("jump")
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	velocity.x = 0
	if (jump and is_on_floor()) or (jump and not double_jump):
		velocity.y = -jump_force
		if not double_jump and not is_on_floor():
			double_jump = true
		
	if left:
		velocity.x -= speed
		if (view_player.scale.x > 0):
			view_player.scale.x = -view_player.scale.x
			
	if right:
		velocity.x += speed
		view_player.scale.x = abs(view_player.scale.x)
	

func _physics_process(delta):
	
	if velocity.length() == 0 and is_on_floor():
		state_machine.travel("idle")
		
	if velocity.x != 0 and is_on_floor():
		state_machine.travel("run")
		
	
	if velocity.y > 0:
		state_machine.travel("jump_down")
		
	if velocity.y < 0:
		state_machine.travel("jump_up")
	
	if is_on_floor():
		double_jump = false
		
	velocity.y += grabity * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))
