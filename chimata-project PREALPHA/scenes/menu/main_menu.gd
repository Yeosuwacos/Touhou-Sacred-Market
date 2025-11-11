extends Node2D

func _ready():
	run()
	
#Runs the main game
func run():	
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
