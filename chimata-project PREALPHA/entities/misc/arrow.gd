extends Area2D

var speed = 400
var type = ""

func _physics_process(delta):
	position -= transform.x * speed * delta
	if type == "up":
		$test.color = Color(0.147, 0.382, 1.0, 1.0)
	elif type == "down":
		$test.color = Color(0.997, 0.0, 0.0, 1.0)
	elif type == "left":
		$test.color = Color(0.0, 0.855, 0.0, 1.0)
	elif type == "right":
		$test.color = Color(0.768, 0.624, 0.254, 1.0)
