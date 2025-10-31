extends Node2D

func _ready():
	#Runs the main game
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
