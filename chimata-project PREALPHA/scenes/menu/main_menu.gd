extends Node2D

func _ready():
	#Sets the game fullscreen
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
#Runs the main game
func run():	
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")

#Start game
func _on_start_pressed() -> void:
	Save.loadGame()
	run()
