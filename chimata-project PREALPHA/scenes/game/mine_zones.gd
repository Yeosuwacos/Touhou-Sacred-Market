extends Node2D


func _ready():
	
	#Place the paths to other locations
	
	$gotoMarket.position = Vector2i(get_viewport_rect().size.x,0)

func _physics_process(delta):
	
	#Verify if Chimata goes left or right
	
	if $gotoMarket.is_colliding():
		get_parent().queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
