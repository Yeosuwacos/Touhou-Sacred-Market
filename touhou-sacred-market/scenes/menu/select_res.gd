extends Node2D

func _on_x_480_pressed() -> void:
	Global.res = Vector2(640,480)
	DisplayServer.window_set_size(Vector2(640,480))
	reload()

func _on_x_720_pressed() -> void:
	Global.res = Vector2(1280,720)
	DisplayServer.window_set_size(Vector2(1280,720))
	reload()

func _on_x_1080_pressed() -> void:
	Global.res = Vector2(1920,1080)
	DisplayServer.window_set_size(Vector2(1920,1080))
	reload()

func _on_x_1440_pressed() -> void:
	Global.res = Vector2(2560,1440)
	DisplayServer.window_set_size(Vector2(2560,1440))
	reload()
	
func _on_x_2160_pressed() -> void:
	Global.res = Vector2(3480,2160)
	DisplayServer.window_set_size(Vector2(3480,2160))
	reload()
	
func _on_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	DisplayServer.window_set_size(Global.res)
	reload()

func _on_windowed_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Global.res)
	reload()

func reload():
	get_parent().queue_free()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
