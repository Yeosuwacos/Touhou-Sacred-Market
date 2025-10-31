extends CharacterBody2D

@export var speed = 500
var ePressed = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	#Walking direction (only left & right) normally
	if Global.isMining == false && Global.follow == false:
		if Input.is_action_pressed("walkLeft"):
			direction.x -= 1
		if Input.is_action_pressed("walkRight"):
			direction.x += 1
		
	#Walking only if we are currently mining, and in corresponding tiles
		
	if Global.isMining == true:
		if Input.is_action_just_pressed("walkLeft"):
			position.x -= 128
		if Input.is_action_just_pressed("walkRight"):
			position.x += 128
		if Input.is_action_just_pressed("walkDown"):
			position.y += 128
		if Input.is_action_just_pressed("walkUp"):
			position.y -= 128
		
	direction = direction.normalized() * speed
	position += direction * delta

	#Manages chimata's camera

	if Global.follow == true:
		$chimataCamera.enabled = true
	else:
		$chimataCamera.enabled = false
