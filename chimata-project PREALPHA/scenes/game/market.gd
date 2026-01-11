extends Node2D

#Preloading Chimata/GUI
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")
@onready var options = preload("res://scenes/menu/menu.tscn")
@onready var optionPopup = options.instantiate()
@onready var minigameSize = Vector2(1280,450)
@onready var cardInterface = Vector2(50,50)

func _ready():
	
	#When loaded, place chimata down on x,y
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2i(Global.res.x/2,get_viewport_rect().size.y - minigameSize.y - 64)
	
	#GUI initialization
	$SellingSystem/CardSale.position = cardInterface
	$SellingSystem/CardSale/Characters.position = Vector2(-50,-50)
	$SellingSystem/GUI/Funds.text = "Funds: " + str(floori(Global.funds))
	
	$SellingSystem/CardSale/Characters/CallChara.position = Vector2(get_viewport_rect().size.x/2 - \
	$SellingSystem/CardSale/Characters/CallChara.size.x/2, chimata.position.y - 64 - cardInterface.y)
	
	#Settings initialization
	add_child(optionPopup)
	optionPopup.position = Vector2i(0,0)
	optionPopup.visible = false

#Settings menu
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if Global.menuOpen == false:
				Global.menuOpen = true
				optionPopup.visible = true
				
			elif Global.menuOpen == true:
				Global.menuOpen = false
				optionPopup.visible = false
