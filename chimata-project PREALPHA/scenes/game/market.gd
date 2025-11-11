extends Node2D

#Preloading Chimata/GUI
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")
@onready var options = preload("res://scenes/menu/menu.tscn")

func _ready():
	
	#When loaded, place chimata down on x,y
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2i(Global.res.x/2,300)
	
	#GUI initialization
	$SellingSystem/CardSale.position = Vector2i(50,50)
	$SellingSystem/GUI.position = Vector2i(Global.res.x-100,Global.res.y-50)
	$SellingSystem/GUI/Funds.text = "Funds: " + str(Global.funds)
	
#Settings menu
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if Global.menuOpen == false:
				Global.menuOpen = true
				var optionPopup = options.instantiate()
				add_child(optionPopup)
				optionPopup.position = Vector2i(Global.res.x/2,Global.res.y/2)
				
			if Global.menuOpen == true:
				Global.menuOpen = false
