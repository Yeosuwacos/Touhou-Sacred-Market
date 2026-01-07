extends Node2D

#Preparing the arrows
@onready var arrowSent = preload("res://entities/misc/arrow.tscn")
@onready var readyArrow: Area2D = null

#Workshop layout
@onready var shopSize = Vector2(2560,450)
@onready var cardChoiceSize = Vector2(480,360)
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")

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
	$BG.size = shopSize
	$BG.position = Vector2(0, get_viewport_rect().size.y - shopSize.y)

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
