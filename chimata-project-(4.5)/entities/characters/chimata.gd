extends CharacterBody2D

@export var speed = 500
var ePressed = false
var flipped = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	var orientation = Vector2.ZERO
	
	#Manages Chimata's orientation
	if Input.is_action_pressed("walkLeft"):
		orientation.x -= 1
	if Input.is_action_pressed("walkRight"):
		orientation.x += 1
		
	if orientation.x > 0:
		$Graphics/Sprite2D.flip_h = false
	if orientation.x < 0:
		$Graphics/Sprite2D.flip_h = true
	
	
	#Walking direction (only left & right) normally
	if Global.isMining == false && Global.follow == false && Global.isMoving == true:
		if Input.is_action_pressed("walkLeft"):
			direction.x -= 1
		if Input.is_action_pressed("walkRight"):
			direction.x += 1
		
	#Walking only if we are currently mining, and in corresponding tiles
		
	if Global.isMining == true:
		if Input.is_action_just_pressed("walkLeft") && Global.maxLEFT == true:
			position.x -= 128
		if Input.is_action_just_pressed("walkRight") && Global.maxRIGHT == true:
			position.x += 128
		if Input.is_action_just_pressed("walkDown") && Global.maxDOWN == true:
			position.y += 128
		if Input.is_action_just_pressed("walkUp") && Global.maxUP == true:
			position.y -= 128
		
	direction = direction.normalized() * speed
	position += direction * delta

	#Manages chimata's camera

	if Global.follow == true:
		$chimataCamera.enabled = true
	else:
		$chimataCamera.enabled = false
