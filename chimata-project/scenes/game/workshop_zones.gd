extends Node2D

#Game settings
@onready var viewport_sizeX = get_viewport().size.x
@onready var game1Counter = 0
@onready var backwards = false
@onready var targetX = 312
@onready var repeats = 0
@onready var cardType = 0

func _ready():
	
	#Place the paths to other locations
	$gotoMarket.position = Vector2(0,0)
	
	#Setup the available card fabrication options
	$cardOptions.position = Vector2i(640,256)
	
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

func _physics_process(delta):
	
	#Verify if Chimata goes left or right
	
	if $gotoMarket.is_colliding():
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
		
	#Animates the 1st minigame's slider
	if Global.game1Running == true:
		#Detects when the slider hits an edge
		if game1Counter == 704:
			backwards = true
		if game1Counter == 0:
			backwards = false
		
		#Moves the counter based on the last edge hit
		if backwards == true:
			game1Counter -= 8
		if backwards == false:
			game1Counter += 8
		
		#Sets the slider's position based on the counter
		$cardMinigames/Game1/Slider.position = Vector2(game1Counter,0)
		
		#Detects the player's hits
		if Input.is_action_just_pressed("confirm"):
			if game1Counter >= 320 && game1Counter <= 400:
				
				#Adds the corresponding card upon a successful hit
				if cardType == 1: 
					Global.ability_card_xs += 1
				if cardType == 2:
					Global.ability_card_s += 1
				if cardType == 3:
					Global.ability_card_m += 1
				if cardType == 4:
					Global.ability_card_l += 1
				if cardType == 5:
					Global.ability_card_xl += 1
					
				#Loops the game as long as needed
				#When over, returns to the workshop
				repeats -= 1
				if repeats == 0:
					Global.game1Running = false
					$cardMinigames/Game1.position = Vector2(5120,2560)
					$cardOptions.position = Vector2i(640,256)
					get_tree().reload_current_scene()

#Card maker minigame
func make_card():
	#Displays the minigame window and enables it
	$cardOptions.position = Vector2(5120,2560)
	$cardMinigames/Game1.position = Vector2(512,256)
	Global.game1Running = true
	cardType = repeats

#Making the first card
func _on_selectXs_pressed():
	if Global.dragon_gem_xs >= 25:
		Global.dragon_gem_xs -= 25
		make_card()
		repeats = 1

#Making the second card
func _on_select_s_pressed():
	if Global.dragon_gem_xs >= 75 && Global.dragon_gem_s >= 25:
		Global.dragon_gem_xs -= 75
		Global.dragon_gem_s -= 25
		make_card()
		repeats = 2

#Making the third card
func _on_select_m_pressed():
	if Global.dragon_gem_xs >= 200 && Global.dragon_gem_s >= 125 && Global.dragon_gem_m >= 50:
		Global.dragon_gem_xs -= 200
		Global.dragon_gem_s -= 125
		Global.dragon_gem_m -= 50
		make_card()
		repeats = 3

#Making the fourth card
func _on_select_l_pressed():
	if Global.dragon_gem_xs >= 350 && Global.dragon_gem_s >= 275 && Global.dragon_gem_m >= 100 \
	&& Global.dragon_gem_l >= 75:
		Global.dragon_gem_xs -= 350
		Global.dragon_gem_s -= 275
		Global.dragon_gem_m -= 100
		Global.dragon_gem_l -= 75
		make_card()
		repeats = 4

#Making the fifth card
func _on_select_xl_pressed():
	if Global.dragon_gem_xs >= 500 && Global.dragon_gem_s >= 400 && Global.dragon_gem_m >= 200 \
	&& Global.dragon_gem_l >= 175 && Global.dragon_gem_xl >= 100:
		Global.dragon_gem_xs -= 500
		Global.dragon_gem_s -= 400
		Global.dragon_gem_m -= 200
		Global.dragon_gem_l -= 175
		Global.dragon_gem_xl -= 100
		make_card()
		repeats = 5
