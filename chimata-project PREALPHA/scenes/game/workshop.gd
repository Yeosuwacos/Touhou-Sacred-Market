extends Node2D

#Preloading GUI
@onready var options = preload("res://scenes/menu/menu.tscn")
@onready var optionPopup = options.instantiate()

func _ready():
	#Settings initialization
	add_child(optionPopup)
	optionPopup.position = Vector2i(9000,3000)
	
#Settings menu
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if Global.menuOpen == false:
				Global.menuOpen = true
				optionPopup.position = Vector2i(Global.res.x/2,Global.res.y/2)
				
			elif Global.menuOpen == true:
				Global.menuOpen = false
				optionPopup.position = Vector2i(9000,3000)
