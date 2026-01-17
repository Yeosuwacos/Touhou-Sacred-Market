extends Node2D

@onready var chimataScene = preload("res://entities/characters/Chimata.tscn")
@onready var options = preload("res://scenes/menu/menu.tscn")
@onready var optionPopup = options.instantiate()

#Interface variables
@onready var shopSize = Global.gameSize
@onready var itemChoiceSize = Vector2(Global.gameSize.x/3, Global.gameSize.y)
@onready var characterSize = Global.charaSize

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
	$Shop.position = Vector2(get_viewport_rect().size.x/2 - itemChoiceSize.x/2 + 50, \
	get_viewport_rect().size.y - itemChoiceSize.y + 50)
	$IdleShop.position = Vector2(get_viewport_rect().size.x/2 - itemChoiceSize.x/2 + 50, \
	get_viewport_rect().size.y - itemChoiceSize.y + 50)
	$ShopGUI/mDialogue.position = Vector2(characterSize.x, get_viewport_rect().size.y - shopSize.y) 
	$ShopGUI/ItemDesc.size = Vector2(get_viewport_rect().size.x - characterSize.x*2, 100)
	$ShopGUI/ItemDesc.position = Vector2(get_viewport_rect().size.x/2 - $ShopGUI/ItemDesc.size.x/2, \
	get_viewport_rect().size.y - $ShopGUI/ItemDesc.size.y)
	
	#Interaction areas placement 
	$Buttons.add_theme_constant_override("separation", get_viewport_rect().size.x/4)
	$Buttons.position = Vector2(get_viewport_rect().size.x/2 - $Buttons.size.x/2, chimata.position.y - 64)
	
	#Character and frame initialization
	$ShopGUI/Characters/Momoyo.scale = characterSize/$ShopGUI/Characters/Momoyo.texture.get_size()
	$ShopGUI/Characters/Momoyo.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/MomoyoFrame.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/MomoyoFrame.scale = characterSize/$ShopGUI/Characters/MomoyoFrame.texture.get_size()
	$ShopGUI/Names/MomoyoName.position = Vector2(characterSize.x/2 - $ShopGUI/Names/MomoyoName.size.x/2, \
	get_viewport_rect().size.y - characterSize.y + 16)
	
	$ShopGUI/Characters/Chimata.scale = characterSize/$ShopGUI/Characters/Chimata.texture.get_size()
	$ShopGUI/Characters/Chimata.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/ChimataFrame.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/ChimataFrame.scale = characterSize/$ShopGUI/Characters/ChimataFrame.texture.get_size()
	$ShopGUI/Names/ChimataName.position = Vector2(get_viewport_rect().size.x - characterSize.x/2 - $ShopGUI/Names/ChimataName.size.x/2, \
	get_viewport_rect().size.y - characterSize.y + 16)
	
	
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
#Shop
func _on_moves_pressed() -> void:
	if Global.funds >= Prices.MoreMoves:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_bombs_pressed() -> void:
	if Global.funds >= Prices.MoreBombs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		
func _on_mult_pressed() -> void:
	if Global.funds >= Prices.Mult:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		
func _on_mult_str_pressed() -> void:
	if Global.funds >= Prices.MultStr:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_bomb_power_pressed() -> void:
	if Global.funds >= Prices.BombPower:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_t_ps_pressed() -> void:
	if Global.funds >= Prices.MoreTPs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_t_ppower_pressed() -> void:
	if Global.funds >= Prices.TPpower:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		
func _on_momoyo_frenzy_pressed() -> void:
	if Global.funds >= Prices.Frenzy:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		
func _on_frenzy_power_pressed() -> void:
	if Global.funds >= Prices.FrenzyPwr:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

#Idle shop
func _on_idler_xs_pressed() -> void:
	if Global.funds >= Prices.idleXs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

func _on_idler_s_pressed() -> void:
	if Global.funds >= Prices.idleS:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy

#Description for every item
func _on_moves_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Grants you 10 extra steps, allowing you to go further down the mines."
func _on_moves_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_bombs_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Grants you 1 bomb, which can be used to dig out every tile around you."
func _on_bombs_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_bomb_power_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Increases the bombs' strength, enabling it to dig out more tiles with one bomb."
func _on_bomb_power_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_t_ps_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Warps you deeper down with only 1 move consumed. Each purchase adds 1 to your teleport item count."
func _on_t_ps_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_t_ppower_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Increases the teleport's range by 5."
func _on_t_ppower_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_mult_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Grants you increased ore yield for 1 move. Each purchase adds 1 to your multiplier count."
func _on_mult_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_mult_str_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Increases the multiplier's ore amount by 1"
func _on_mult_str_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""
	
func _on_momoyo_frenzy_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Summons Momoyo to bore down the tiles adjacent and under you. Each purchase adds 1 to your frenzy count."
func _on_momoyo_frenzy_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""
	
func _on_frenzy_power_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Increases Momoyo's frenzy strength. Each purchase increases depth by 3"
func _on_frenzy_power_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""
	
func _exit_tree():
	Save.saveGame()
