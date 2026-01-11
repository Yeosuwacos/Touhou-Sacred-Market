extends Node2D

@onready var chimataScene = preload("res://entities/characters/Chimata.tscn")
@onready var options = preload("res://scenes/menu/menu.tscn")
@onready var optionPopup = options.instantiate()

#Interface variables
@onready var shopSize = Vector2(1280,450)
@onready var itemChoiceSize = Vector2(480,360)
@onready var characterSize = Vector2(360,450)

#Momoyo texture
@onready var momoyo = load("res://assets/sprites/Momoyo.png")
@onready var momoyoHappy = load("res://assets/sprites/MomoyoHappy.png")

@onready var currentHover = ""

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
	
	#Interaction areas placement 
	$Buttons.add_theme_constant_override("separation", get_viewport_rect().size.x/4)
	$Buttons.position = Vector2(get_viewport_rect().size.x/2 - $Buttons.size.x/2, chimata.position.y - 64)
	
	#Character and frame initialization
	$ShopGUI/Characters/Momoyo.scale = characterSize/$ShopGUI/Characters/Momoyo.texture.get_size()
	$ShopGUI/Characters/Momoyo.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/MomoyoFrame.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Names/MomoyoName.position = Vector2(characterSize.x/2 - $ShopGUI/Names/MomoyoName.size.x/2, \
	get_viewport_rect().size.y - characterSize.y + 12)
	
	$ShopGUI/Characters/Chimata.scale = characterSize/$ShopGUI/Characters/Chimata.texture.get_size()
	$ShopGUI/Characters/Chimata.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/ChimataFrame.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Names/ChimataName.position = Vector2(get_viewport_rect().size.x - characterSize.x/2 - $ShopGUI/Names/ChimataName.size.x/2, \
	get_viewport_rect().size.y - characterSize.y + 12)
	
	
	#Hides the shop until the button is pressed
	Global.mShopOpen = false
	Global.iShopOpen = false
	
	$ShopGUI.visible = false
	$Shop.visible = false
	$IdleShop.visible = false

#Confirmation detection
func _on_start_mining_body_entered(_body) -> void:
	currentHover = "mining"
	$Buttons/Mining/StartMining/pressE.visible = true
func _on_start_mining_body_exited(_body) -> void:
	currentHover = ""
	$Buttons/Mining/StartMining/pressE.visible = false
	
func _on_shop_button_body_entered(_body) -> void:
	currentHover = "shop"
	$Buttons/Shop/ShopButton/pressE.visible = true
func _on_shop_button_body_exited(_body) -> void:
	currentHover = ""
	$Buttons/Shop/ShopButton/pressE.visible = false
	
func _on_idle_shop_button_body_entered(_body) -> void:
	currentHover = "idleShop"
	$Buttons/IdleShop/IdleShopButton/pressE.visible = true
func _on_idle_shop_button_body_exited(_body) -> void:
	currentHover = ""
	$Buttons/IdleShop/IdleShopButton/pressE.visible = false

func _input(event):
	#Settings menu
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if Global.menuOpen == false:
				Global.menuOpen = true
				optionPopup.visible = true
				
			elif Global.menuOpen == true:
				Global.menuOpen = false
				optionPopup.visible = false
		
		#Button selection
		if Input.is_action_pressed("confirm"):
			match currentHover:
				"": pass
				
				"mining": get_tree().call_deferred("change_scene_to_file", "res://scenes/game/mine_minigame.tscn")
				
				"shop":
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
					$ShopGUI/Characters/Momoyo.texture = momoyo
					
				"idleShop":
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
						$ShopGUI/Characters/Momoyo.texture = momoyo

#Momoyo expressions
func _on_moves_pressed() -> void:
	if Global.funds >= Prices.MoreMoves:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_bombs_pressed() -> void:
	if Global.funds >= Prices.MoreBombs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_bomb_power_pressed() -> void:
	if Global.funds >= Prices.BombPower:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_t_ps_pressed() -> void:
	if Global.funds >= Prices.MoreTPs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_idler_xs_pressed() -> void:
	if Global.funds >= Prices.idleXs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_idler_s_pressed() -> void:
	if Global.funds >= Prices.idleS:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
