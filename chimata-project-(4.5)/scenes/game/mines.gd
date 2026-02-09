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
	$GUI/GenUI.scale = Global.res / $GUI/GenUI.texture.get_size()
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
	
	#Funds UI
	$UI/Funds.text = str(floori(Global.funds))
	$UI/Funds.position = Vector2(24,24)
	
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
							$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
							
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
		Global.funds -= Prices.MoreMoves
		Global.moves += 25
		Prices.MoreMovesBought += 1
		Prices.MoreMoves += 50*Prices.MoreMovesBought**1.2
		$Shop/ShopGrid/MovesText.text = "+25 stamina: " + str(floori(Prices.MoreMoves))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

func _on_mult_pressed() -> void:
	if Global.funds >= Prices.Mult:
		Global.funds -= Prices.Mult
		Global.multQty += 1
		Prices.MultBought += 1
		Prices.Mult += 50*Prices.MultBought**1.7
		
		if Global.multQty == 10:
			$Shop/ShopGrid/MultText.text = "+1 ore multiplier: MAX"
		else:
			$Shop/ShopGrid/MultText.text = "+1 ore multiplier: " + str(floori(Prices.Mult))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))
		
func _on_mult_str_pressed() -> void:
	if Global.funds >= Prices.MultStr:
		Global.funds -= Prices.MultStr
		Global.multStr += 1
		Prices.MultStrBought += 1
		Prices.MultStr += 100*Prices.MultStrBought**1.2
		$Shop/ShopGrid/MultStrText.text = "+1 multiplier strength: " + str(floori(Prices.MultStr))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))
		
func _on_bombs_pressed() -> void:
	if Global.funds >= Prices.MoreBombs:
		Global.funds -= Prices.MoreBombs
		Global.bombQty += 1
		Prices.MoreBombsBought += 1
		Prices.MoreBombs += 100*Prices.MoreBombsBought**1.4
		
		if Global.bombQty == 10:
			$Shop/ShopGrid/BombsText.text = "+1 bomb: MAX"
		else:
			$Shop/ShopGrid/BombsText.text = "+1 bomb: " + str(floori(Prices.MoreBombs))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

func _on_bomb_power_pressed() -> void:
	if Global.funds >= Prices.BombPower:
		Global.funds -= Prices.BombPower
		Global.bombStr += 1
		Prices.BombPowerBought += 1
		Prices.BombPower += 500*Prices.BombPowerBought**1.6
		$Shop/ShopGrid/BombPowerText.text = "+Bomb power: " + str(floori(Prices.BombPower))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

func _on_t_ps_pressed() -> void:
	if Global.funds >= Prices.MoreTPs:
		Global.funds -= Prices.MoreTPs
		Global.tpQty += 1
		Prices.MoreTPsBought += 1
		Prices.MoreTPs += 200*Prices.MoreTPsBought**1.3
		
		if Global.tpQty == 10:
			$Shop/ShopGrid/TPsText.text = "+1 teleport: MAX"
		else:
			$Shop/ShopGrid/TPsText.text = "+1 teleport: " + str(floori(Prices.MoreTPs))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

func _on_t_ppower_pressed() -> void:
	if Global.funds >= Prices.TPpower:
		Global.funds -= Prices.TPpower
		Global.tpStr += 5
		Prices.TPpowerBought += 1
		Prices.TPpower += 300*Prices.TPpowerBought**1.5
		$Shop/ShopGrid/TPpowerText.text = "+5 teleport power: " + str(floori(Prices.TPpower))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))
		
func _on_momoyo_frenzy_pressed() -> void:
	if Global.funds >= Prices.Frenzy:
		Global.funds -= Prices.Frenzy
		Global.frenzyQty += 1
		Prices.FrenzyBought += 1
		Prices.Frenzy += 250*Prices.FrenzyBought**1.35
		if Global.frenzyQty == 10:
			$Shop/ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: MAX"
		else:
			$Shop/ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: " + str(floori(Prices.Frenzy))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))
		
func _on_frenzy_power_pressed() -> void:
	if Global.funds >= Prices.FrenzyPwr:
		Global.funds -= Prices.FrenzyPwr
		Global.frenzyStr += 3
		Prices.FrenzyPwrBought += 1
		Prices.FrenzyPwr += 400*Prices.FrenzyPwrBought**1.4
		$Shop/ShopGrid/FrenzyPowerText.text = "+3 frenzy power: " + str(floori(Prices.FrenzyPwr))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

#Idle shop
func _on_idler_xs_pressed() -> void:
	if Global.funds >= Prices.idleXs:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

func _on_idler_s_pressed() -> void:
	if Global.funds >= Prices.idleS:
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$UI/Funds.text = str(floori(Global.funds))

#Description for every item
func _on_moves_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Grants you 25 extra stamina, allowing you to go further down the mines."
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
	$ShopGUI/ItemDesc.text = "Warps you deeper down with only 1 stamina consumed. Each purchase adds 1 to your teleport item count."
func _on_t_ps_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_t_ppower_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Increases the teleport's range by 5."
func _on_t_ppower_mouse_exited() -> void:
	$ShopGUI/ItemDesc.text = ""

func _on_mult_mouse_entered() -> void:
	$ShopGUI/ItemDesc.text = "Grants you increased ore yield for your next tile mined. Each purchase adds 1 to your multiplier count."
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
