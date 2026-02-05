extends CharacterBody2D

@export var speed = 500
@export var gravity = 900
var ePressed = false
var orient = Vector2.RIGHT
var direction = Vector2.ZERO

func _physics_process(delta):
	direction = Vector2.ZERO
	direction.x = Input.get_action_strength("walkRight") - Input.get_action_strength("walkLeft")
	direction.y = Input.get_action_strength("walkDown") - Input.get_action_strength("walkUp")
	
	#Orientation
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		orient = direction
		$Graphics/Sprite2D.flip_h = direction.x < 0
	
	#Movement
	velocity.x = direction.x * speed
	
	if Global.isMining:
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	if Input.is_action_just_pressed("walkUp") && is_on_floor():
		velocity.y = -600
		
	move_and_slide()
	
	#Manages chimata's camera
	if Global.follow == true:
		$chimataCamera.enabled = true
	else:
		$chimataCamera.enabled = false
