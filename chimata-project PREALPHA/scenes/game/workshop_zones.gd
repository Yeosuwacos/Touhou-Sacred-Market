extends Node2D

#Preparing the arrows
@onready var arrowSent = preload("res://entities/misc/arrow.tscn")
@onready var readyArrow: Area2D = null

#Workshop layout
@onready var viewX = get_viewport_rect().size.x
@onready var viewY = get_viewport_rect().size.y
@onready var characterSize = Global.charaSize
@onready var shopSize = Vector2(Global.gameSize.x*2, Global.gameSize.y)
@onready var cardChoiceSize = Vector2(Global.gameSize.x/3, Global.gameSize.y)
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")
@onready var currentHover = ""
@onready var workshopOpen = false

#Variables
@onready var type = {
	1: "up",
	2: "down",
	3: "left",
	4: "right"
}
@onready var setType = ""
@onready var regType = ""
@onready var orient = 0
@onready var mult = 0
@onready var hits = 0
@onready var chimata = chimataScene.instantiate()

func _ready():
	add_child(chimata)
	chimata.position = Vector2(50,get_viewport_rect().size.y - shopSize.y - 64)
	
	#Frames and character sprites
	$Characters/Megumu.scale = characterSize/$Characters/Megumu.texture.get_size()
	$Characters/Megumu.position = Vector2(characterSize.x/2, viewY - characterSize.y/2)
	$Characters/MegumuFrame.position = Vector2(characterSize.x/2, viewY - characterSize.y/2)
	$Characters/MegumuFrame.scale = characterSize/$Characters/MegumuFrame.texture.get_size()
	
	$Characters/Chimata.scale = characterSize/$Characters/Chimata.texture.get_size()
	$Characters/Chimata.position = Vector2(viewX - characterSize.x/2, viewY - characterSize.y/2)
	$Characters/ChimataFrame.position = Vector2(viewX - characterSize.x/2, viewY - characterSize.y/2)
	$Characters/ChimataFrame.scale = characterSize/$Characters/ChimataFrame.texture.get_size()
	
	$Names/ChimataName.position = Vector2(viewX - characterSize.x/2 - \
	$Names/ChimataName.size.x/2, viewY - 48)
	$Names/MegumuName.position = Vector2(characterSize.x/2 - \
	$Names/MegumuName.size.x/2, viewY - 48)
	
	#Place the paths to other locations
	$gotoMarket.position = Vector2(0,0)
	
	#Setup the available card fabrication options
	$shopGUI.visible = true
	update_prices()
	
	#Keep the indicator invisible
	$cardMinigames/Hitzone/Indicator.visible = false
	
	#Places down the different workshop elements
	$shopGUI.position = Vector2(get_viewport_rect().size.x/2 - cardChoiceSize.x/2, \
	get_viewport_rect().size.y - cardChoiceSize.y)
	$shopGUI/BG.size = shopSize
	$shopGUI/BG.position = Vector2(0 - $shopGUI.position.x, get_viewport_rect().size.y - shopSize.y - $shopGUI.position.y)
	$Buttons.add_theme_constant_override("separation", get_viewport_rect().size.y/3)
	$Buttons.position = Vector2(get_viewport_rect().size.x/2 - $Buttons.size.x/2, chimata.position.y - 64)

func _physics_process(delta):
	
	#Verify if Chimata goes left or right
	if $gotoMarket.is_colliding():
		get_parent().queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
	
	#Detects the action pressed to check the right move
	if Input.is_action_just_pressed("walkUp"):
		regType = "up"
	elif Input.is_action_just_pressed("walkDown"):
		regType = "down"
	elif Input.is_action_just_pressed("walkLeft"):
		regType = "left"
	elif Input.is_action_just_pressed("walkRight"):
		regType = "right"
		
	#Hit system for the minigame
	if readyArrow and regType != "":
		if readyArrow.type == regType:
			hits += 1
		readyArrow.queue_free()
		readyArrow = null

	regType = "" # prevent duplicate hits

#Updates the prices every second for the idler
func _on_updater_timeout() -> void:
	update_prices()

#Updates all the prices
func update_prices():
	$shopGUI/cardOptions/cards/PriceXs.text = "Card 1\r" + str(Global.dragon_gem_xs) + "/25 dragon gem dust"

	$shopGUI/cardOptions/cards/PriceS.text = "Card 2\r" + str(Global.dragon_gem_xs) + "/75 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/25 dragon gem piece"
	
	$shopGUI/cardOptions/cards/PriceM.text = "Card 3\r" + str(Global.dragon_gem_xs) + "/200 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/125 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/50 dragon gems"
	
	$shopGUI/cardOptions/cards/PriceL.text = "Card 4\r" + str(Global.dragon_gem_xs) + "/350 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/275 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/100 dragon gems\r" + \
	str(Global.dragon_gem_l) + "/75 dragon gem chunks"

	$shopGUI/cardOptions/cards/PriceXl.text = "Card 5\r" + str(Global.dragon_gem_xs) + "/500 dragon gem dust\r" +\
	str(Global.dragon_gem_s) + "/400 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/200 dragon gems\r" + \
	str(Global.dragon_gem_l) + "/175 dragon gem chunks\r" + str(Global.dragon_gem_xl) + "/100 dragon gem clusters"

#Initiates the rhythm game
func play(card,rep):
	#Prevents Chimata from moving and locks the camera onto her
	Global.isMoving = false
	Global.follow = true
	#Sets up the playing field & variables
	mult = 0
	hits = 0
	$shopGUI.visible = false
	$cardMinigames/Hitzone/Indicator.visible = true
	$cardMinigames/Hitzone.position = Vector2(chimata.position.x-188, 50)
	$cardMinigames/Repeater.wait_time = 1 - 0.1*card
	$cardMinigames/Repeater.start()
	for i in range(0,rep):
		#Creates the notes in intervals
		selOrient()
		var arrow = arrowSent.instantiate()
		add_child(arrow)
		arrow.type = type[orient]
		arrow.position = Vector2i($cardMinigames/Hitzone.position.x + 600,$cardMinigames/Hitzone.position.y+32)
		arrow.speed = 400
		await $cardMinigames/Repeater.timeout
	$cardMinigames/Repeater.wait_time = 3 + 0.2*card
	await $cardMinigames/Repeater.timeout
	$cardMinigames/Repeater.stop()
	
	#Calculates the rounded multiplier and gives out the correct amount of cards
	mult = ceili(hits/card)
	match card:
		1: Global.ability_card_xs += mult
		2: Global.ability_card_s += mult
		3: Global.ability_card_m += mult
		4: Global.ability_card_l += mult
		5: Global.ability_card_xl += mult
		
	#Updates the display
	$cardMinigames/Repeater.stop()
	update_prices()
	$shopGUI.visible = true
	$cardMinigames/Hitzone/Indicator.visible = false
	
	#Makes Chimata able to move again and unlocks the camera
	Global.isMoving = true
	Global.follow = false

#Randomizes the orientation
func selOrient():
	orient = randi_range(1,4)

#Making the first card
func _on_selectXs_pressed():
	if Global.dragon_gem_xs >= 25:
		Global.dragon_gem_xs -= 25
		play(1,3)

#Making the second card
func _on_select_s_pressed():
	if Global.dragon_gem_xs >= 75 && Global.dragon_gem_s >= 25:
		Global.dragon_gem_xs -= 75
		Global.dragon_gem_s -= 25
		play(2,6)

#Making the third card
func _on_select_m_pressed():
	if Global.dragon_gem_xs >= 200 && Global.dragon_gem_s >= 125 && Global.dragon_gem_m >= 50:
		Global.dragon_gem_xs -= 200
		Global.dragon_gem_s -= 125
		Global.dragon_gem_m -= 50
		play(3,9)

#Making the fourth card
func _on_select_l_pressed():
	if Global.dragon_gem_xs >= 350 && Global.dragon_gem_s >= 275 && Global.dragon_gem_m >= 100 \
	&& Global.dragon_gem_l >= 75:
		Global.dragon_gem_xs -= 350
		Global.dragon_gem_s -= 275
		Global.dragon_gem_m -= 100
		Global.dragon_gem_l -= 75
		play(4,12)

#Making the fifth card
func _on_select_xl_pressed():
	if Global.dragon_gem_xs >= 500 && Global.dragon_gem_s >= 400 && Global.dragon_gem_m >= 200 \
	&& Global.dragon_gem_l >= 175 && Global.dragon_gem_xl >= 100:
		Global.dragon_gem_xs -= 500
		Global.dragon_gem_s -= 400
		Global.dragon_gem_m -= 200
		Global.dragon_gem_l -= 175
		Global.dragon_gem_xl -= 100
		play(5,15)

#Manages the arrow game detection
func _on_hitzone_area_entered(area: Area2D):
	Global.hittable = true
	readyArrow = area

func _on_hitzone_area_exited(area: Area2D):
	Global.hittable = false
	if readyArrow == area:
		readyArrow = null
	area.queue_free()

#Opens the buttons
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if Input.is_action_pressed("confirm"):
			match currentHover:
				"": pass
				"cardMaking":
					if !workshopOpen:
						$shopGUI.visible = true
						$Characters.visible = true
						$Names.visible = true
						workshopOpen = true
					elif workshopOpen:
						$shopGUI.visible = false
						$Characters.visible = false
						$Names.visible = false
						workshopOpen = false
				"idleShop":
					pass

#Hovering interactions for buttons
func _on_c_moptions_body_entered(_body) -> void:
	currentHover = "cardMaking"
	$Buttons/CardMaking/CMoptions/pressE.visible = true
func _on_c_moptions_body_exited(_body) -> void:
	currentHover = ""
	$Buttons/CardMaking/CMoptions/pressE.visible = false

func _on_idle_shop_button_body_entered(_body) -> void:
	currentHover = "idleShop"
	$Buttons/IdleShop/IdleShopButton/pressE.visible = true
func _on_idle_shop_button_body_exited(_body) -> void:
	currentHover = ""
	$Buttons/IdleShop/IdleShopButton/pressE.visible = false
