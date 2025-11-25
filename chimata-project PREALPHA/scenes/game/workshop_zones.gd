extends Node2D

#Preparing the arrows
@onready var arrowSent = preload("res://entities/misc/arrow.tscn")
@onready var readyArrow: Area2D = null

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

func _ready():
	
	#Place the paths to other locations
	$gotoMarket.position = Vector2(0,0)
	
	#Setup the available card fabrication options
	$cardOptions.visible = true
	
	$cardOptions/cardXs/Price.text = "Card 1\r" + str(Global.dragon_gem_xs) + "/25 dragon gem dust"

	$cardOptions/cardS/Price.text = "Card 2\r" + str(Global.dragon_gem_xs) + "/75 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/25 dragon gem piece"
	
	$cardOptions/cardM/Price.text = "Card 3\r" + str(Global.dragon_gem_xs) + "/200 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/125 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/50 dragon gems"
	
	$cardOptions/cardL/Price.text = "Card 4\r" + str(Global.dragon_gem_xs) + "/350 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/275 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/100 dragon gems\r" + \
	str(Global.dragon_gem_l) + "/75 dragon gem chunks"

	$cardOptions/cardXl/Price.text = "Card 5\r" + str(Global.dragon_gem_xs) + "/500 dragon gem dust\r" +\
	str(Global.dragon_gem_s) + "/400 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/200 dragon gems\r" + \
	str(Global.dragon_gem_l) + "/175 dragon gem chunks\r" + str(Global.dragon_gem_xl) + "/100 dragon gem clusters"

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
	
#Initiates the rhythm game
func play(card,rep):
	#Prevents Chimata from moving and locks the camera onto her
	Global.isMoving = false
	Global.follow = true
	#Sets up the playing field & variables
	mult = 0
	hits = 0
	$cardOptions.visible = false
	$cardMinigames/Repeater.wait_time = 1 - 0.1*card
	$cardMinigames/Repeater.start()
	for i in range(0,rep):
		#Creates the notes in intervals
		selOrient()
		var arrow = arrowSent.instantiate()
		add_child(arrow)
		arrow.type = type[orient]
		arrow.position = Vector2i(600,$cardMinigames/Hitzone.position.y+32)
		arrow.speed = 400
		await $cardMinigames/Repeater.timeout
	$cardMinigames/Repeater.wait_time = 3
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
	$cardOptions/cardXs/Price.text = "Card 1\r" + str(Global.dragon_gem_xs) + "/25 dragon gem dust"

	$cardOptions/cardS/Price.text = "Card 2\r" + str(Global.dragon_gem_xs) + "/75 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/25 dragon gem piece"
	
	$cardOptions/cardM/Price.text = "Card 3\r" + str(Global.dragon_gem_xs) + "/200 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/125 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/50 dragon gems"
	
	$cardOptions/cardL/Price.text = "Card 4\r" + str(Global.dragon_gem_xs) + "/350 dragon gem dust\r" + \
	str(Global.dragon_gem_s) + "/275 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/100 dragon gems\r" + \
	str(Global.ability_card_l) + "/75 dragon gem chunks"

	$cardOptions/cardXl/Price.text = "Card 5\r" + str(Global.dragon_gem_xs) + "/500 dragon gem dust\r" +\
	str(Global.dragon_gem_s) + "/400 dragon gem pieces\r" + str(Global.dragon_gem_m) + "/200 dragon gems\r" + \
	str(Global.ability_card_l) + "/175 dragon gem chunks\r" + str(Global.dragon_gem_xl) + "/100 dragon gem clusters"
	$cardOptions.visible = true
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
