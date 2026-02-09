extends Node2D

@onready var second = 0.0

#Adds gems every second based on gems per second
func _physics_process(delta):
	second += delta
	if second >= 1.0:
		second = 0.0
		
		Global.dragon_gem_xs += Global.idleXs
		Global.dragon_gem_s += Global.idleS
		Global.dragon_gem_m += Global.idleM
		Global.dragon_gem_l += Global.idleL
		Global.dragon_gem_xl += Global.idleXl
