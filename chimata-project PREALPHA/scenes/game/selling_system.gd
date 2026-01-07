extends Node2D

#Layout for minigames
@onready var minigameSize = Vector2(1280,450)
@onready var gameAreaSize = Vector2(480,360)
@onready var characterSize = Vector2(360,450)
@onready var viewX = get_viewport_rect().size.x
@onready var viewY = get_viewport_rect().size.y

#Refreshes the card labels
func _ready():
	$CardSale/Buttons/AddRem/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)
	$CardSale/Buttons/AddRem/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)
	$CardSale/Buttons/AddRem/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)
	$CardSale/Buttons/AddRem/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)
	$CardSale/Buttons/AddRem/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

	#Sets the scale for characters

	$CardSale/Characters/Sakuya.scale = characterSize/$CardSale/Characters/Sakuya.texture.get_size()
	$CardSale/Characters/Sakuya.position = Vector2(characterSize.x/2, get_viewport_rect().size.y - characterSize.y/2)
	
	#Creates the layout for the interface
	
	$BG.size = minigameSize
	$BG.position = Vector2(0, get_viewport_rect().size.y - minigameSize.y)
	$minigameGUI/Bartering/HigherLower.position = Vector2(viewX/2 - gameAreaSize.x/2, viewY - gameAreaSize.y/2)
	$CardSale/Characters/dialogue.position = Vector2(characterSize.x, viewY - minigameSize.y) 
	
	$BG.visible = false
	$minigameGUI/Bartering/HigherLower.visible = false
	$minigameGUI/Bartering/Blackjack.visible = false
	$minigameGUI/Bartering/Cashout.visible = false
	$CardSale/Buttons.visible = false
	$CardSale/Characters/dialogue.visible = false
	
	#Hides the characters
	$CardSale/Characters/Sakuya.visible = false
	
	#Places the character calling buttons in good proportions
	
	$CardSale/Characters/CallChara.add_theme_constant_override("separation", viewX/5)
	$CardSale/Characters/CallChara.position = Vector2(viewX/2 - $CardSale/Characters/CallChara.size.x/2, 50)
	$CardSale/Buttons.position = Vector2(viewX/2 - gameAreaSize.x/2, viewY - gameAreaSize.y)
	$CardSale/Buttons/Sell.visible = false
	$CardSale/Buttons/HiLo.visible = false
	$CardSale/Buttons/Blackjack.visible = false

#Picks the right character and begins a sale

func _on_reimu_sale_pressed() -> void:
	$CardSale/Buttons.visible = true
	$CardSale/Buttons/Sell.visible = true
	$CardSale/Buttons/HiLo.visible = false
	$CardSale/Buttons/Blackjack.visible = false
	$BG.visible = true

	$CardSale/Characters/Sakuya.visible = false
	
	$CardSale/Characters/dialogue.visible = true

func _on_sakuya_hi_lo_pressed() -> void:
	$CardSale/Buttons.visible = true
	$CardSale/Buttons/HiLo.visible = true
	$CardSale/Buttons/Sell.visible = false
	$CardSale/Buttons/Blackjack.visible = false
	$BG.visible = true
	
	$CardSale/Characters/Sakuya.visible = true
	
	$CardSale/Characters/dialogue.visible = true
	$CardSale/Characters/dialogue.text = Dialogue.HiLoLines.pick_random()

func _on_marisa_blackjack_pressed() -> void:
	$CardSale/Buttons.visible = true
	$CardSale/Buttons/Blackjack.visible = true
	$CardSale/Buttons/Sell.visible = false
	$CardSale/Buttons/HiLo.visible = false
	$BG.visible = true
	
	$CardSale/Characters/Sakuya.visible = false
	
	$CardSale/Characters/dialogue.visible = true

func _on_sanae_roulette_pressed() -> void:
	pass # Replace with function body.

#Adding or removing cards for sale

#Xs
func _on_add_xs_pressed() -> void:
	if Global.sold_xs < Global.ability_card_xs:
		Global.sold_xs += 1
		$CardSale/Buttons/AddRem/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)

func _on_rem_xs_pressed() -> void:
	if Global.sold_xs > 0:
		Global.sold_xs -= 1
		$CardSale/Buttons/AddRem/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)

#S
func _on_add_s_pressed() -> void:
	if Global.sold_s < Global.ability_card_s:
		Global.sold_s += 1
		$CardSale/Buttons/AddRem/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)

func _on_rem_s_pressed() -> void:
	if Global.sold_s > 0:
		Global.sold_s -= 1
		$CardSale/Buttons/AddRem/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)

#M
func _on_add_m_pressed() -> void:
	if Global.sold_m < Global.ability_card_m:
		Global.sold_m += 1
		$CardSale/Buttons/AddRem/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)

func _on_rem_m_pressed() -> void:
	if Global.sold_m > 0:
		Global.sold_m -= 1
		$CardSale/Buttons/AddRem/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)

#L
func _on_add_l_pressed() -> void:
	if Global.sold_l < Global.ability_card_l:
		Global.sold_l += 1
		$CardSale/Buttons/AddRem/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)

func _on_rem_l_pressed() -> void:
	if Global.sold_l > 0:
		Global.sold_l -= 1
		$CardSale/Buttons/AddRem/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)

#Xl
func _on_add_xl_pressed() -> void:
	if Global.sold_xl < Global.ability_card_xl:
		Global.sold_xl += 1
		$CardSale/Buttons/AddRem/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

func _on_rem_xl_pressed() -> void:
	if Global.sold_xl > 0:
		Global.sold_xl -= 1
		$CardSale/Buttons/AddRem/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

#Selling the desired cards without bartering
func _on_sell_pressed() -> void:
	var total = 0
	total += (Global.sold_xs * 50 + Global.sold_s * 300 + Global.sold_m * \
	825 + Global.sold_l * 2150 + Global.sold_xl * 5400)
	remove_stock()
	sell(total)

#Bartering interface (minigames)

#Higher-lower minigame
func _on_hi_lo_pressed() -> void:
	var total = 0
	total += (Global.sold_xs * 50 + Global.sold_s * 300 + Global.sold_m * \
	825 + Global.sold_l * 2150 + Global.sold_xl * 5400)
	if total > 0:
		$CardSale/Buttons.visible = false
		$CardSale/Characters/CallChara.visible = false
		$CardSale/Characters/dialogue.text = ""
		HigherLower(total)

func HigherLower(wager):
	$minigameGUI/Bartering/HigherLower.visible = true
	Global.wager = wager
	Global.nb1 = randi_range(3,10)
	Global.nb2 = randi_range(1,12)
	
	#Makes sure the two numbers arent equal
	while Global.nb2 == Global.nb1:
		Global.nb2 = randi_range(1,12)
	
	$minigameGUI/Bartering/HigherLower/Card1.text = str(Global.nb1)
	
#Variables for the higher-lower minigame
func _on_higher_pressed() -> void:
	$minigameGUI/Bartering/HigherLower/Card2.text = str(Global.nb2)
	if Global.nb1 < Global.nb2:
		Global.wager *= 1.25
		$minigameGUI/Bartering/HigherLower/Card2.text += ": Win!"
	elif Global.nb1 > Global.nb2:
		Global.wager *= 0.75
		$minigameGUI/Bartering/HigherLower/Card2.text += ": Lose!"
	$minigameGUI/Bartering/Cashout.visible = true

func _on_lower_pressed() -> void:
	$minigameGUI/Bartering/HigherLower/Card2.text = str(Global.nb2)
	if Global.nb1 > Global.nb2:
		Global.wager *= 1.25
		$minigameGUI/Bartering/HigherLower/Card2.text += ": Win!"
	elif Global.nb1 < Global.nb2:
		Global.wager *= 0.75
		$minigameGUI/Bartering/HigherLower/Card2.text += ": Lose!"
	$minigameGUI/Bartering/Cashout.visible = true

#Blackjack minigame
func _on_blackjack_pressed() -> void:
	var total = 0
	total += (Global.sold_xs * 50 + Global.sold_s * 300 + Global.sold_m * \
	825 + Global.sold_l * 2150 + Global.sold_xl * 5400)
	if total > 0:
		$CardSale/Buttons.visible = false
		$CardSale/Characters/CallChara.visible = false
		Blackjack(total)
		
func Blackjack(wager):
	$minigameGUI/Bartering/Blackjack.visible = true
	Global.wager = wager
	var starterCard1 = randi_range(1,10)
	var starterCard2 = randi_range(1,10)
	Global.playerHand = starterCard1 + starterCard2
	Global.marisaHand = starterCard1 + starterCard2
	$minigameGUI/Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
	$minigameGUI/Bartering/Blackjack/OpponentNb.text = str(Global.marisaHand)
	$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(BlDisplayCard(starterCard1))
	$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(BlDisplayCard(starterCard2))
	$minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.add_child(BlDisplayCard(starterCard1))
	$minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.add_child(BlDisplayCard(starterCard2))
	
#Hitting adds a card while doubling down adds two and ends the turn
	
func _on_hit_pressed() -> void:
	if Global.playerHand < 21:
		var drawnCard = randi_range(1,10)
		Global.playerHand += drawnCard
		$minigameGUI/Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
		$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(BlDisplayCard(drawnCard))
		checkBust()
	
func _on_d_down_pressed() -> void:
	$minigameGUI/Bartering/Blackjack/DDown.disabled = true
	if Global.playerHand < 21:
		var drawnCard1 = randi_range(1,13)
		var drawnCard2 = randi_range(1,13)
		Global.playerHand += drawnCard1
		Global.playerHand += drawnCard2
		$minigameGUI/Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
		$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(BlDisplayCard(drawnCard1))
		$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(BlDisplayCard(drawnCard2))
		checkBust()

func _on_stand_pressed() -> void:
	disable()
	while Global.marisaHand < 17:
		var drawnCard =  randi_range(1,13)
		Global.marisaHand += drawnCard
		$minigameGUI/Bartering/Blackjack/OpponentNb.text = str(Global.marisaHand)
		$minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.add_child(BlDisplayCard(drawnCard))
		
	if Global.marisaHand == Global.playerHand:
		$minigameGUI/Bartering/Blackjack/PlayerNb.text += " - Draw!"
		
	elif Global.marisaHand < Global.playerHand || Global.marisaHand > 21: 
		$minigameGUI/Bartering/Blackjack/PlayerNb.text += " - Win!"
		Global.wager *= 1.5
		
	else: 
		$minigameGUI/Bartering/Blackjack/PlayerNb.text += " - Lose!"
		Global.wager *= 0.5
	$minigameGUI/Bartering/Cashout.visible = true

func checkBust():
	if Global.playerHand > 21:
		$minigameGUI/Bartering/Blackjack/PlayerNb.text += " - Bust!"
		Global.wager *= 0.5
		disable()
		$minigameGUI/Bartering/Cashout.visible = true
	elif Global.playerHand == 21:
		$minigameGUI/Bartering/Blackjack/PlayerNb.text += " - Blackjack!"
		Global.wager *= 1.5
		disable()
		$minigameGUI/Bartering/Cashout.visible = true
	elif $minigameGUI/Bartering/Blackjack/DDown.disabled == true:
		_on_stand_pressed()
		
#Creating and matching the right card to the sprites for display
func BlDisplayCard(cardNo):
	var card = TextureRect.new()
	var png = null
	match cardNo:
		1: png = load("res://assets/game elements/BlCards/ace_of_spades.png")
		2: png = load("res://assets/game elements/BlCards/2_of_spades.png")
		3: png = load("res://assets/game elements/BlCards/3_of_spades.png")
		4: png = load("res://assets/game elements/BlCards/4_of_spades.png")
		5: png = load("res://assets/game elements/BlCards/5_of_spades.png")
		6: png = load("res://assets/game elements/BlCards/6_of_spades.png")
		7: png = load("res://assets/game elements/BlCards/7_of_spades.png")
		8: png = load("res://assets/game elements/BlCards/8_of_spades.png")
		9: png = load("res://assets/game elements/BlCards/9_of_spades.png")
		10: png = load("res://assets/game elements/BlCards/10_of_spades.png")
		11: png = load("res://assets/game elements/BlCards/jack_of_spades.png")
		12: png = load("res://assets/game elements/BlCards/queen_of_spades.png")
		13: png = load("res://assets/game elements/BlCards/king_of_spades.png")
	card.texture = png
	return card

#Disables the buttons
func disable():
	$minigameGUI/Bartering/Blackjack/Hit.disabled = true
	$minigameGUI/Bartering/Blackjack/DDown.disabled = true
	$minigameGUI/Bartering/Blackjack/Stand.disabled = true

#Confirming a sale and updating the amount
func sell(total):
	Global.funds += total
	$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
	$minigameGUI/Bartering/HigherLower.visible = false
	$minigameGUI/Bartering/Blackjack.visible = false

#Removing the sold items/secondary variables
func remove_stock():
	Global.ability_card_xs -= Global.sold_xs
	Global.ability_card_s -= Global.sold_s
	Global.ability_card_m -= Global.sold_m
	Global.ability_card_l -= Global.sold_l
	Global.ability_card_xl -= Global.sold_xl
	
	Global.sold_xs = 0
	Global.sold_s = 0
	Global.sold_m = 0
	Global.sold_l = 0
	Global.sold_xl = 0
	
	$minigameGUI/Bartering/HigherLower/Card1.text = ""
	$minigameGUI/Bartering/HigherLower/Card2.text = ""
	
	$CardSale/Buttons/AddRem/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)
	$CardSale/Buttons/AddRem/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)
	$CardSale/Buttons/AddRem/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)
	$CardSale/Buttons/AddRem/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)
	$CardSale/Buttons/AddRem/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

#Ends the bartering process
func _on_cashout_pressed() -> void:
	remove_stock()
	sell(ceili(Global.wager))
	$minigameGUI/Bartering/Cashout.visible = false
	$minigameGUI/Bartering/Blackjack/Hit.disabled = false
	$minigameGUI/Bartering/Blackjack/Stand.disabled = false
	$minigameGUI/Bartering/Blackjack/DDown.disabled = false
	
	$CardSale.visible = true
	$CardSale/Buttons.visible = true
	$CardSale/Characters/CallChara.visible = true
	
	var removeYourHand = $minigameGUI/Bartering/Blackjack/BlCards/YourCards.get_children()
	var removeMarisaHand = $minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.get_children()
	discard(removeYourHand)
	discard(removeMarisaHand)

#Clears up the cards (visually)
func discard(hand):
	for card in hand:
		card.queue_free()
