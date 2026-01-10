extends Node2D

@onready var chimataScene = preload("res://entities/characters/chimata.tscn")
@onready var options = preload("res://scenes/menu/menu.tscn")
@onready var optionPopup = options.instantiate()

#Interface variables
@onready var shopSize = Vector2(1280,450)
@onready var itemChoiceSize = Vector2(480,360)
@onready var characterSize = Vector2(360,450)

#Momoyo texture
@onready var momoyo = load("res://assets/sprites/momoyo.png")
@onready var momoyoHappy = load("res://assets/sprites/momoyoHappy.png")

func _ready():
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2i(Global.res.x-50,get_viewport_rect().size.y - shopSize.y - 64)
	
	#Settings/GUI initialization
	add_child(optionPopup)
	optionPopup.position = Vector2i(0,0)
	optionPopup.visible = false
	$ShopGUI/BG.size = shopSize
	$ShopGUI/BG.position = Vector2(0, get_viewport_rect().size.y - shopSize.y)
	$Shop.position = Vector2(get_viewport_rect().size.x/2 - itemChoiceSize.x/2, \
	get_viewport_rect().size.y - itemChoiceSize.y)
	$IdleShop.position = Vector2(get_viewport_rect().size.x/2 - itemChoiceSize.x/2, \
	get_viewport_rect().size.y - itemChoiceSize.y)
	$ShopGUI/mDialogue.position = Vector2(characterSize.x, get_viewport_rect().size.y - shopSize.y) 
	
	#Character and frame initialization
	$ShopGUI/Momoyo.scale = characterSize/$ShopGUI/Momoyo.texture.get_size()
	$ShopGUI/Momoyo.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/MomoyoFrame.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	
	$ShopGUI/Chimata.scale = characterSize/$ShopGUI/Chimata.texture.get_size()
	$ShopGUI/Chimata.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/ChimataFrame.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	
	#Hides the shop until the button is pressed
	Global.mShopOpen = false
	Global.iShopOpen = false
	
	$ShopGUI.visible = false
	$Shop.visible = false
	$IdleShop.visible = false

#Opens the mine shop
func _on_shop_button_pressed() -> void:
	if Global.mShopOpen == false:
		$ShopGUI/mDialogue.text = Dialogue.mineShopLines.pick_random()
		$ShopGUI.visible = true
		$Shop.visible = true
		Global.mShopOpen = true
		$Shop/GUI/Funds.text = "Funds: " + str(floori(Global.funds))
		
		$IdleShop.visible = false
		Global.iShopOpen = false
		
	elif Global.mShopOpen == true:
		$Shop.visible = false
		$ShopGUI.visible = false
		Global.mShopOpen = false
	$ShopGUI/Momoyo.texture = momoyo
		
#Opens the idle shop
func _on_idle_shop_button_pressed() -> void:
	if Global.iShopOpen == false:
		$ShopGUI/mDialogue.text = Dialogue.idleShopLines.pick_random()
		$ShopGUI.visible = true
		$IdleShop.visible = true
		Global.iShopOpen = true
		$IdleShop/GUI/Funds.text = "Funds: " + str(floori(Global.funds))
		
		$Shop.visible = false
		Global.mShopOpen = false
		
		
	elif Global.iShopOpen == true:
		$ShopGUI.visible = false
		$IdleShop.visible = false
		Global.iShopOpen = false
	$ShopGUI/Momoyo.texture = momoyo

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

#Momoyo expressions
func _on_moves_pressed() -> void:
	if Global.funds >= Prices.MoreMoves:
		$ShopGUI/Momoyo.texture = momoyoHappy

func _on_bombs_pressed() -> void:
	if Global.funds >= Prices.MoreBombs:
		$ShopGUI/Momoyo.texture = momoyoHappy

func _on_bomb_power_pressed() -> void:
	if Global.funds >= Prices.BombPower:
		$ShopGUI/Momoyo.texture = momoyoHappy

func _on_t_ps_pressed() -> void:
	if Global.funds >= Prices.MoreTPs:
		$ShopGUI/Momoyo.texture = momoyoHappy

func _on_idler_xs_pressed() -> void:
	if Global.funds >= Prices.idleXs:
		$ShopGUI/Momoyo.texture = momoyoHappy

func _on_idler_s_pressed() -> void:
	if Global.funds >= Prices.idleS:
		$ShopGUI/Momoyo.texture = momoyoHappy
