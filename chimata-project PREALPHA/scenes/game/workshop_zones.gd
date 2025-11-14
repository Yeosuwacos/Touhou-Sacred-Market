extends Node2D

#Preparing the arrows
@onready var arrowSent = preload("res://entities/misc/arrow.tscn")

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
		
	#Hit system for the minigame
	if Global.hittable == true:
		if Input.is_action_just_pressed("confirm"):
			print("blep")

#Initiates the rhythm game
func play(card,rep):
	$cardOptions.visible = false
	$cardMinigames/Repeater.wait_time = 1 - 0.1*card
	$cardMinigames/Repeater.start()
	for i in range(0,rep):
		#Creates the notes in intervals
		var arrow = arrowSent.instantiate()
		add_child(arrow)
		arrow.position = Vector2i(600,$cardMinigames/Hitzone.position.y+16)
		arrow.speed = 400
		await $cardMinigames/Repeater.timeout
	#Updates the display
	await $cardMinigames/Repeater.timeout
	await $cardMinigames/Repeater.timeout
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

func _on_hitzone_area_exited(area: Area2D):
	Global.hittable = false
	area.queue_free()
