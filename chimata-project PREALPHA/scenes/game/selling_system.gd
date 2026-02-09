extends Node2D

#Layout for minigames
@onready var minigameSize = Global.gameSize
@onready var gameAreaSize = Vector2(Global.gameSize.x/3,Global.gameSize.y)
@onready var characterSize = Global.charaSize
@onready var nanaScale = 0.85
@onready var viewX = get_viewport_rect().size.x
@onready var viewY = get_viewport_rect().size.y
@onready var currentHover = ""

#Refreshes the card labels
func _ready():
	$CardSale/Buttons/AddRem/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)
	$CardSale/Buttons/AddRem/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)
	$CardSale/Buttons/AddRem/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)
	$CardSale/Buttons/AddRem/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)
	$CardSale/Buttons/AddRem/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

	#Sets the scale/layout for the characters and the frames

	$CardSale/Characters/Sprites/OpponentFrame.position = Vector2(characterSize.x/2, viewY - characterSize.y/2)
	$CardSale/Characters/Sprites/OpponentFrame.scale = characterSize/$CardSale/Characters/Sprites/OpponentFrame.texture.get_size()

	$CardSale/Characters/Sprites/Sakuya.scale = characterSize/$CardSale/Characters/Sprites/Sakuya.texture.get_size()*nanaScale
	$CardSale/Characters/Sprites/Sakuya.position = Vector2(characterSize.x/2, viewY - nanaScale*characterSize.y/2)
	
	$CardSale/Characters/Sprites/Chimata.scale = characterSize/$CardSale/Characters/Sprites/Chimata.texture.get_size()
	$CardSale/Characters/Sprites/Chimata.position = Vector2(viewX - characterSize.x/2, viewY - characterSize.y/2)
	$CardSale/Characters/Sprites/ChimataFrame.position = Vector2(viewX - characterSize.x/2, viewY - characterSize.y/2)
	$CardSale/Characters/Sprites/ChimataFrame.scale = characterSize/$CardSale/Characters/Sprites/ChimataFrame.texture.get_size()
	
	#Creates the layout for the interface
	
	$BG.size = minigameSize
	$BG.position = Vector2(0, get_viewport_rect().size.y - minigameSize.y)
	$minigameGUI/Bartering/HigherLower.position = Vector2(viewX/2 - gameAreaSize.x/2, viewY - gameAreaSize.y)
	$minigameGUI/Bartering/Blackjack.position = Vector2(viewX/2 - gameAreaSize.x/2, viewY - gameAreaSize.y)
	$minigameGUI/Bartering/CardFlip.position = Vector2(viewX/2 - gameAreaSize.x/2, viewY - gameAreaSize.y)
	$CardSale/Characters/dialogue.position = Vector2(characterSize.x, viewY - minigameSize.y) 
	
	$CardSale/Characters/Names/ChimataName.position = Vector2(viewX - characterSize.x/2 - \
	$CardSale/Characters/Names/ChimataName.size.x/2, viewY - 48)
	$CardSale/Characters/Names/OpponentName.position = Vector2(characterSize.x/2 - \
	$CardSale/Characters/Names/OpponentName.size.x/2, viewY - 48)
	
	#Places the character calling buttons in good proportions
	
	$CardSale/Characters/CallChara.add_theme_constant_override("separation", viewX/5)
	$CardSale/Buttons.position = Vector2(viewX/2 - gameAreaSize.x/2, viewY - gameAreaSize.y)

#Replaces the opponent names correctly
func replace():
	$CardSale/Characters/Names/OpponentName.position = Vector2(characterSize.x/2 - \
	$CardSale/Characters/Names/OpponentName.size.x/2, viewY - 48)

#Picks the right character and begins a sale
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if Input.is_action_pressed("confirm"):
			match currentHover:
				"": pass
				
				"reimu":
					$CardSale/Buttons.visible = true
					$CardSale/Buttons/Sell.visible = true
					$CardSale/Buttons/HiLo.visible = false
					$CardSale/Buttons/Blackjack.visible = false
					$CardSale/Buttons/CardFlip.visible = false
					
					$CardSale/Characters/Sprites/OpponentFrame.visible = true
					$CardSale/Characters/Sprites/ChimataFrame.visible = true
					$BG.visible = true

					$CardSale/Characters/Sprites/Sakuya.visible = false
					$CardSale/Characters/Sprites/Chimata.visible = true
					
					$CardSale/Characters/Names/ChimataName.visible = true
					$CardSale/Characters/Names/OpponentName.text = "Reimu"
					$CardSale/Characters/Names/OpponentName.visible = true
					$CardSale/Characters/dialogue.visible = true
					$CardSale/Characters/dialogue.text = ""
					
				"sakuya":
					$CardSale/Buttons.visible = true
					$CardSale/Buttons/HiLo.visible = true
					$CardSale/Buttons/Sell.visible = false
					$CardSale/Buttons/Blackjack.visible = false
					$CardSale/Buttons/CardFlip.visible = false
					
					$CardSale/Characters/Sprites/OpponentFrame.visible = true
					$CardSale/Characters/Sprites/ChimataFrame.visible = true
					$BG.visible = true
					
					$CardSale/Characters/Sprites/Sakuya.visible = true
					$CardSale/Characters/Sprites/Chimata.visible = true
					
					$CardSale/Characters/Names/ChimataName.visible = true
					$CardSale/Characters/Names/OpponentName.text = "Sakuya"
					$CardSale/Characters/Names/OpponentName.visible = true
					$CardSale/Characters/dialogue.visible = true
					$CardSale/Characters/dialogue.text = Dialogue.HiLoLines.pick_random()
					
				"marisa":
					$CardSale/Buttons.visible = true
					$CardSale/Buttons/Blackjack.visible = true
					$CardSale/Buttons/Sell.visible = false
					$CardSale/Buttons/HiLo.visible = false
					$CardSale/Buttons/CardFlip.visible = false
					
					$CardSale/Characters/Sprites/OpponentFrame.visible = true
					$CardSale/Characters/Sprites/ChimataFrame.visible = true
					$BG.visible = true
					
					$CardSale/Characters/Sprites/Sakuya.visible = false
					$CardSale/Characters/Sprites/Chimata.visible = true
					
					$CardSale/Characters/Names/ChimataName.visible = true
					$CardSale/Characters/Names/OpponentName.text = "Marisa"
					$CardSale/Characters/Names/OpponentName.visible = true
					$CardSale/Characters/dialogue.visible = true
					$CardSale/Characters/dialogue.text = ""
					
				"sanae":
					$CardSale/Buttons/CardFlip.visible = true
					$CardSale/Buttons.visible = true
					$CardSale/Buttons/Sell.visible = false
					$CardSale/Buttons/HiLo.visible = false
					$CardSale/Buttons/Blackjack.visible = false
					
					$CardSale/Characters/Sprites/OpponentFrame.visible = true
					$CardSale/Characters/Sprites/ChimataFrame.visible = true
					$BG.visible = true
					
					$CardSale/Characters/Sprites/Sakuya.visible = false
					$CardSale/Characters/Sprites/Chimata.visible = true
					
					$CardSale/Characters/Names/ChimataName.visible = true
					$CardSale/Characters/Names/OpponentName.text = "Sanae"
					$CardSale/Characters/Names/OpponentName.visible = true
					$CardSale/Characters/dialogue.visible = true
					$CardSale/Characters/dialogue.text = ""
			replace()

#Detection functions for character sales

func _on_reimu_sale_body_entered(_body) -> void: 
	currentHover = "reimu"
	$CardSale/Characters/CallChara/Reimu/ReimuSale/pressE.visible = true
func _on_reimu_sale_body_exited(_body) -> void: 
	currentHover = ""
	$CardSale/Characters/CallChara/Reimu/ReimuSale/pressE.visible = false

func _on_sakuya_hi_lo_body_entered(_body) -> void: 
	currentHover = "sakuya"
	$CardSale/Characters/CallChara/Sakuya/SakuyaHiLo/pressE.visible = true
func _on_sakuya_hi_lo_body_exited(_body) -> void: 
	currentHover = ""
	$CardSale/Characters/CallChara/Sakuya/SakuyaHiLo/pressE.visible = false

func _on_marisa_blackjack_body_entered(_body) -> void:
	currentHover = "marisa"
	$CardSale/Characters/CallChara/Marisa/MarisaBlackjack/pressE.visible = true
func _on_marisa_blackjack_body_exited(_body) -> void:
	currentHover = ""
	$CardSale/Characters/CallChara/Marisa/MarisaBlackjack/pressE.visible = false
	
func _on_sanae_card_flip_body_entered(_body) -> void:
	currentHover = "sanae"
	$CardSale/Characters/CallChara/Sanae/SanaeCardFlip/pressE.visible = true
func _on_sanae_card_flip_body_exited(_body) -> void:
	currentHover = ""
	$CardSale/Characters/CallChara/Sanae/SanaeCardFlip/pressE.visible = false

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
	
	$minigameGUI/Bartering/HigherLower/Cards.add_child(DisplayCard(Global.nb1))
	
#Variables for the higher-lower minigame
func _on_higher_pressed() -> void:
	$minigameGUI/Bartering/HigherLower/Cards.add_child(DisplayCard(Global.nb2))
	if Global.nb1 < Global.nb2:
		Global.wager *= 1.25
		$minigameGUI/Bartering/HigherLower/CardText.text += ": Win!"
	elif Global.nb1 > Global.nb2:
		Global.wager *= 0.75
		$minigameGUI/Bartering/HigherLower/CardText.text += ": Lose!"
	$minigameGUI/Bartering/Cashout.visible = true

func _on_lower_pressed() -> void:
	$minigameGUI/Bartering/HigherLower/Cards.add_child(DisplayCard(Global.nb2))
	if Global.nb1 > Global.nb2:
		Global.wager *= 1.25
		$minigameGUI/Bartering/HigherLower/CardText.text += ": Win!"
	elif Global.nb1 < Global.nb2:
		Global.wager *= 0.75
		$minigameGUI/Bartering/HigherLower/CardText.text += ": Lose!"
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
	$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(DisplayCard(starterCard1))
	$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(DisplayCard(starterCard2))
	$minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.add_child(DisplayCard(starterCard1))
	$minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.add_child(DisplayCard(starterCard2))
	
#Hitting adds a card while doubling down adds two and ends the turn
	
func _on_hit_pressed() -> void:
	if Global.playerHand < 21:
		var drawnCard = randi_range(1,10)
		Global.playerHand += drawnCard
		$minigameGUI/Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
		$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(DisplayCard(drawnCard))
		checkBust()
	
func _on_d_down_pressed() -> void:
	$minigameGUI/Bartering/Blackjack/DDown.disabled = true
	if Global.playerHand < 21:
		var drawnCard1 = randi_range(1,13)
		var drawnCard2 = randi_range(1,13)
		Global.playerHand += drawnCard1
		Global.playerHand += drawnCard2
		$minigameGUI/Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
		$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(DisplayCard(drawnCard1))
		$minigameGUI/Bartering/Blackjack/BlCards/YourCards.add_child(DisplayCard(drawnCard2))
		checkBust()

func _on_stand_pressed() -> void:
	disable()
	while Global.marisaHand < 17:
		var drawnCard =  randi_range(1,13)
		Global.marisaHand += drawnCard
		$minigameGUI/Bartering/Blackjack/OpponentNb.text = str(Global.marisaHand)
		$minigameGUI/Bartering/Blackjack/BlCards/MarisaCards.add_child(DisplayCard(drawnCard))
		
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

#Disables the buttons
func disable():
	$minigameGUI/Bartering/Blackjack/Hit.disabled = true
	$minigameGUI/Bartering/Blackjack/DDown.disabled = true
	$minigameGUI/Bartering/Blackjack/Stand.disabled = true
	$minigameGUI/Bartering/CardFlip/Pick1.disabled = true
	$minigameGUI/Bartering/CardFlip/Pick2.disabled = true
	$minigameGUI/Bartering/CardFlip/Pick3.disabled = true

#Card flip minigame
var card1 = 1
var card2 = 1
var card3 = 1
var card1val = 0
var card2val = 0
var card3val = 0
var index = 0

func _on_card_flip_pressed() -> void:
	var total = 0
	total += (Global.sold_xs * 50 + Global.sold_s * 300 + Global.sold_m * \
	825 + Global.sold_l * 2150 + Global.sold_xl * 5400)
	if total > 0:
		$CardSale/Buttons.visible = false
		$CardSale/Characters/CallChara.visible = false
		$CardSale/Characters/dialogue.text = ""
		card_flip(total)

func card_flip(wager):
	$minigameGUI/Bartering/CardFlip.visible = true
	Global.wager = wager
	var mult = randi_range(10,70)
	var misfortune = 1 - float(mult)/100
	var fortune = 1 + float(mult)/100
	var selector: Array = [1,2,3]
	card_attribute(fortune, misfortune, selector)

#Gives every card a specific attribute 
func card_attribute(fortune, misfortune, selector):
	index = randi_range(0,2)
	card1 = selector.pop_at(index)
	index = randi_range(0,1)
	card2 = selector.pop_at(index)
	card3 = selector.pop_at(0)
	
	card1val = distribute(card1,fortune,misfortune, "shuffle")
	card2val = distribute(card2,fortune,misfortune, "shuffle")
	card3val = distribute(card3,fortune,misfortune, "shuffle")
	
func distribute(card, fortune, misfortune, action):
	var payout = 0
	match action:
		"shuffle":
			match card:
				1: payout = misfortune
				2: payout = 1
				3: payout = fortune
			return payout
		
		"reveal":
			match card:
				1: 
					Global.wager = Global.wager*card1val
					flipResult(card1val)
				2: 
					Global.wager = Global.wager*card2val
					flipResult(card2val)
				3: 
					Global.wager = Global.wager*card3val
					flipResult(card3val)
			$minigameGUI/Bartering/Cashout.visible = true
			disable()

#Sets up the buttons for when you make your choice
func _on_pick_1_pressed() -> void:
	distribute(card1,null,null,"reveal")
func _on_pick_2_pressed() -> void:
	distribute(card2,null,null,"reveal")
func _on_pick_3_pressed() -> void:
	distribute(card3,null,null,"reveal")
	
func flipResult(value):
	if value == 1:
		$CardSale/Characters/dialogue.text = "Regular luck! x1"
	elif value > 1:
		$CardSale/Characters/dialogue.text = "Fortune! x" + str(value)
	elif value < 1:
		$CardSale/Characters/dialogue.text = "Misfortune! x" + str(value)

#Creating and matching the right card to the sprites for display
func DisplayCard(cardNo):
	var card = TextureRect.new()
	var png = null
	match cardNo:
		1: png = load("res://assets/game elements/BlCards/1_Shinmyoumaru.png")
		2: png = load("res://assets/game elements/BlCards/2_of_spades.png")
		3: png = load("res://assets/game elements/BlCards/3_Wriggle.png")
		4: png = load("res://assets/game elements/BlCards/4_of_spades.png")
		5: png = load("res://assets/game elements/BlCards/5_Momiji.png")
		6: png = load("res://assets/game elements/BlCards/6_Hecatia.png")
		7: png = load("res://assets/game elements/BlCards/7_of_spades.png")
		8: png = load("res://assets/game elements/BlCards/8_of_spades.png")
		9: png = load("res://assets/game elements/BlCards/9_Cirno.png")
		10: png = load("res://assets/game elements/BlCards/10_Mayumi.png")
		11: png = load("res://assets/game elements/BlCards/jack_of_spades.png")
		12: png = load("res://assets/game elements/BlCards/queen_of_spades.png")
		13: png = load("res://assets/game elements/BlCards/K_Shikieiki.png")
	card.texture = png
	return card

#Confirming a sale and updating the amount
func sell(total):
	Global.funds += total
	$GUI/Funds.text = str(floori(Global.funds))
	$minigameGUI/Bartering/HigherLower.visible = false
	$minigameGUI/Bartering/Blackjack.visible = false
	$minigameGUI/Bartering/CardFlip.visible = false

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
	
	var removeSakuyaCard = $minigameGUI/Bartering/HigherLower/Cards.get_children()
	discard(removeSakuyaCard)
	
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
	$minigameGUI/Bartering/CardFlip/Pick1.disabled = false
	$minigameGUI/Bartering/CardFlip/Pick2.disabled = false
	$minigameGUI/Bartering/CardFlip/Pick3.disabled = false
	
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
