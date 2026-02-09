extends Node2D

func _ready():
	
	#Place the paths to other locations
	
	$gotoMine.position = Vector2(0,0)
	$gotoWorkshop.position = Vector2(get_viewport_rect().size.x,0)

func _physics_process(delta):
	
	#Verify if Chimata goes left or right
	
	if $gotoMine.is_colliding():
		get_parent().queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/mines.tscn")
	
	if $gotoWorkshop.is_colliding():
		get_parent().queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/workshop.tscn")
