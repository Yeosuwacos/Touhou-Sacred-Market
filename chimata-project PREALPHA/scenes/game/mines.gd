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

const itemDesc = {
	"moves": "Grants you 25 extra stamina, allowing you to go further down the mines.",
	"bombs": "Grants you 1 bomb, which can be used to dig out every tile around you.",
	"bombPwr": "Increases the bombs' strength.",
	"tps": "Warps you deeper down with only 1 stamina consumed.",
	"tpPwr": "Increases teleport range by 5.",
	"mults": "Grants increased ore yield for your next tile mined.",
	"multPwr": "Increases multiplier strength by 1.",
	"frenzies": "Summons Momoyo to dig nearby tiles.",
	"frenzyPwr": "Increases frenzy depth by 3."
}

func _ready():
	refresher()
	
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
	$Trophies.position = Vector2(get_viewport_rect().size.x/2 - itemChoiceSize.x/2 + 50, \
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
	get_viewport_rect().size.y - 40)
	
	$ShopGUI/Characters/Chimata.scale = characterSize/$ShopGUI/Characters/Chimata.texture.get_size()
	$ShopGUI/Characters/Chimata.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/ChimataFrame.position = Vector2(get_viewport_rect().size.x - characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	$ShopGUI/Characters/ChimataFrame.scale = characterSize/$ShopGUI/Characters/ChimataFrame.texture.get_size()
	$ShopGUI/Names/ChimataName.position = Vector2(get_viewport_rect().size.x - characterSize.x/2 - $ShopGUI/Names/ChimataName.size.x/2, \
	get_viewport_rect().size.y - 40)
	
	#Hides the shop until the button is pressed
	Global.mShopOpen = false
	Global.iShopOpen = false
	
	$ShopGUI.visible = false
	$Shop.visible = false
	$Trophies.visible = false

#Updates the pricing for upgrades
func refresher():
	# Main shop
	updater("MoreMoves", "moves", "+25 stamina: ", $Shop/ShopGrid/MovesText, null)
	updater("Mult", "multQty", "+1 ore multiplier: ", $Shop/ShopGrid/MultText, 10)
	updater("MultStr", "multStr", "+1 multiplier strength: ", $Shop/ShopGrid/MultStrText, 10)
	updater("MoreBombs", "bombQty", "+1 bomb: ", $Shop/ShopGrid/BombsText, 5)
	updater("BombPower", "bombStr", "+Bomb power: ", $Shop/ShopGrid/BombPowerText, 5)
	updater("MoreTPs", "tpQty", "+1 teleport: ", $Shop/ShopGrid/TPsText, 5)
	updater("TPpower", "tpStr", "+5 teleport power: ", $Shop/ShopGrid/TPpowerText, 10)
	updater("Frenzy", "frenzyQty", "+1 frenzy: ", $Shop/ShopGrid/MomoyoFrenzyText, 5)
	updater("FrenzyPwr", "frenzyStr", "+3 frenzy power: ", $Shop/ShopGrid/FrenzyPowerText, 10)
	
	# Idle shop
	updater("idleXs", "idleXs", "+1 dust gatherer: ", $Shop/IdleShopGrid/idlerXsText, null)
	updater("idleS", "idleS", "+1 ore gatherer: ", $Shop/IdleShopGrid/idlerSText, null)
	updater("idleM", "idleM", "+1 gem gatherer: ", $Shop/IdleShopGrid/idlerMText, null)
	updater("idleL", "idleL", "+1 chunk gatherer: ", $Shop/IdleShopGrid/idlerLText, null)
	updater("idleXl", "idleXl", "+1 cluster gatherer: ", $Shop/IdleShopGrid/idlerXlText, null)
	
	#Price tag
	$Shop/GUI/Funds.text = str(floori(Global.funds))

func updater(price, upg, textEdit, label, max):
	var bought = Prices.get(price + "Bought")

	if max != null && bought >= max:
		label.text = textEdit + " MAX"
	else:
		label.text = textEdit + str(floori(Prices.get(price)))

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
						
						$Trophies.visible = false
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
							$Trophies.visible = true
							Global.iShopOpen = true
							$Shop/GUI/Funds.text = "Funds: " + str(floori(Global.funds))
							
							$Shop.visible = false
							Global.mShopOpen = false
							
							
						elif Global.iShopOpen == true:
							$ShopGUI.visible = false
							$Trophies.visible = false
							Global.iShopOpen = false
						$ShopGUI/Characters/Momoyo.texture = momoyo


#Special upgrades panel
func _on_special_upgrades_pressed() -> void:
	pass 

#Shop
func _on_moves_pressed() -> void:
	purchase("MoreMoves","moves",25,100,1.2,$Shop/ShopGrid/MovesText,"+25 stamina: ",Prices.MoreMovesBought,null)

func _on_mult_pressed() -> void:
	purchase("Mult","multQty",1,350,1.2,$Shop/ShopGrid/MultText,"+1 ore multiplier: ",Prices.MultBought,10)

func _on_mult_str_pressed() -> void:
	purchase("MultStr","multStr",1,250,1.5,$Shop/ShopGrid/MultStrText,"+1 multiplier strength: ",Prices.MultStrBought,10)

func _on_bombs_pressed() -> void:
	purchase("MoreBombs","bombQty",1,200,1.4,$Shop/ShopGrid/BombsText,"+1 bomb: ",Prices.MoreBombsBought,5)

func _on_bomb_power_pressed() -> void:
	purchase("BombPower","bombStr",1,500,1.6,$Shop/ShopGrid/BombPowerText,"+Bomb power: ",Prices.BombPowerBought,5)

func _on_t_ps_pressed() -> void:
	purchase("MoreTPs","tpQty",1,600,1.3,$Shop/ShopGrid/TPsText,"+1 teleport: ",Prices.MoreTPsBought,5)

func _on_t_ppower_pressed() -> void:
	purchase("TPpower","tpStr",5,750,1.5,$Shop/ShopGrid/TPpowerText,"+5 teleport power: ",Prices.TPpowerBought,10)

func _on_momoyo_frenzy_pressed() -> void:
	purchase("Frenzy","frenzyQty",1,1000,1.35,$Shop/ShopGrid/MomoyoFrenzyText,"+1 frenzy: ",Prices.FrenzyBought,5)

func _on_frenzy_power_pressed() -> void:
	purchase("FrenzyPwr","frenzyStr",1,1350,1.4,$Shop/ShopGrid/FrenzyPowerText,"+3 frenzy power: ", Prices.FrenzyPwrBought,10)

#Idle shop
func _on_idler_xs_pressed() -> void:
	purchase("idleXs","idleXs",1,1000,2,$Shop/IdleShopGrid/idlerXsText,"+1 dust gatherer: ",Prices.idleXsBought,null)

func _on_idler_s_pressed() -> void:
	purchase("idleS","idleS",1,1500,2.2,$Shop/IdleShopGrid/idlerSText,"+ 1 ore gatherer: ",Prices.idleSBought,null)
		
func _on_idler_m_pressed() -> void:
	purchase("idleM","idleM",1,2000,2.4,$Shop/IdleShopGrid/idlerMText,"+ 1 gem gatherer: ",Prices.idleMBought,null)

func _on_idler_l_pressed() -> void:
	purchase("idleL","idleL",1,3000,2.6,$Shop/IdleShopGrid/idlerLText,"+ 1 chunk gatherer: ",Prices.idleLBought,null)

func _on_idler_xl_pressed() -> void:
	purchase("idleXl","idleXl",1,5000,2.8,$Shop/IdleShopGrid/idlerXlText,"+ 1 cluster gatherer: ",Prices.idleXlBought,null)

#Universal upgrade system
func purchase(price,upg,addUpg,basePrice,pwr,text,textContent,current,max):
	if Global.funds < Prices.get(price): return
	if max != null && current >= max: 
		text.text = textContent + " MAX"
		return
	Global.funds -= Prices.get(price)
	Global.set(upg, Global.get(upg) + addUpg)
	
	var upgBought = price + "Bought"
	Prices.set(upgBought, Prices.get(upgBought) + 1)
	Prices.set(price,basePrice*pow(Prices.get(upgBought) + 1,pwr))
	
	if max != null && current >= max-1:
		text.text = textContent + " MAX"
	else:
		text.text = textContent + str(floori(Prices.get(price)))
		$ShopGUI/Characters/Momoyo.texture = momoyoHappy
		$Shop/GUI/Funds.text = str(floori(Global.funds))

#Item description functions (on hover
func showDesc(item):
	$ShopGUI/ItemDesc.text = itemDesc.get(item, "")

func clearDesc():
	$ShopGUI/ItemDesc.text = ""

func _exit_tree():
	Save.saveGame()
