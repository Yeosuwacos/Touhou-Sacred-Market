extends Node2D

@onready var viewport_sizeX = get_viewport().size.x

func _ready():
	
	#Place the paths to other locations
	
	$gotoMarket.position.x = viewport_sizeX

func _physics_process(delta):
	
	#Verify if Chimata goes left or right
	
	if $gotoMarket.is_colliding():
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")


func _on_start_mining_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/mine_minigame.tscn")
