extends Node2D

#Refreshes the card labels
func _ready():
	$CardSale/Labels/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)
	$CardSale/Labels/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)
	$CardSale/Labels/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)
	$CardSale/Labels/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)
	$CardSale/Labels/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)
	
	#Adjusts Sakuya's scale
	$Bartering/HigherLower/Sakuya.scale = Vector2(400.0/$Bartering/HigherLower/Sakuya.texture.get_width(), \
	500.0/$Bartering/HigherLower/Sakuya.texture.get_height())

#Adding or removing cards for sale

#Xs
func _on_add_xs_pressed() -> void:
	if Global.sold_xs < Global.ability_card_xs:
		Global.sold_xs += 1
		$CardSale/Labels/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)

func _on_rem_xs_pressed() -> void:
	if Global.sold_xs > 0:
		Global.sold_xs -= 1
		$CardSale/Labels/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)

#S
func _on_add_s_pressed() -> void:
	if Global.sold_s < Global.ability_card_s:
		Global.sold_s += 1
		$CardSale/Labels/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)

func _on_rem_s_pressed() -> void:
	if Global.sold_s > 0:
		Global.sold_s -= 1
		$CardSale/Labels/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)

#M
func _on_add_m_pressed() -> void:
	if Global.sold_m < Global.ability_card_m:
		Global.sold_m += 1
		$CardSale/Labels/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)

func _on_rem_m_pressed() -> void:
	if Global.sold_m > 0:
		Global.sold_m -= 1
		$CardSale/Labels/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)

#L
func _on_add_l_pressed() -> void:
	if Global.sold_l < Global.ability_card_l:
		Global.sold_l += 1
		$CardSale/Labels/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)

func _on_rem_l_pressed() -> void:
	if Global.sold_l > 0:
		Global.sold_l -= 1
		$CardSale/Labels/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)

#Xl
func _on_add_xl_pressed() -> void:
	if Global.sold_xl < Global.ability_card_xl:
		Global.sold_xl += 1
		$CardSale/Labels/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

func _on_rem_xl_pressed() -> void:
	if Global.sold_xl > 0:
		Global.sold_xl -= 1
		$CardSale/Labels/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

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
		HigherLower(total)

func HigherLower(wager):
	$Bartering/HigherLower.position = Vector2(900,300)
	Global.wager = wager
	Global.nb1 = randi_range(3,10)
	Global.nb2 = randi_range(1,12)
	
	#Makes sure the two numbers arent equal
	while Global.nb2 == Global.nb1:
		Global.nb2 = randi_range(1,12)
	
	$Bartering/HigherLower/Card1.text = str(Global.nb1)

#Blackjack minigame
func _on_blackjack_pressed() -> void:
	var total = 0
	total += (Global.sold_xs * 50 + Global.sold_s * 300 + Global.sold_m * \
	825 + Global.sold_l * 2150 + Global.sold_xl * 5400)
	if total > 0:
		Blackjack(total)
		
func Blackjack(wager):
	$Bartering/Blackjack.position = Vector2(900,300)
	Global.wager = wager
	var starterCard1 = randi_range(1,10)
	var starterCard2 = randi_range(1,10)
	Global.playerHand = starterCard1 + starterCard2
	Global.marisaHand = starterCard1 + starterCard2
	$Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
	$Bartering/Blackjack/OpponentNb.text = str(Global.marisaHand)
	
	#Hitting adds a card, while doubling down adds two and ends the turn
	
func _on_hit_pressed() -> void:
	if Global.playerHand < 21:
		Global.playerHand += randi_range(1,10)
		$Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
		checkBust()
	
func _on_d_down_pressed() -> void:
	$Bartering/Blackjack/DDown.disabled = true
	if Global.playerHand < 21:
		Global.playerHand += randi_range(1,10)
		Global.playerHand += randi_range(1,10)
		$Bartering/Blackjack/PlayerNb.text = str(Global.playerHand)
		checkBust()

func _on_stand_pressed() -> void:
	$Bartering/Blackjack/Hit.disabled = true
	$Bartering/Blackjack/DDown.disabled = true
	$Bartering/Blackjack/Stand.disabled = true
	while Global.marisaHand < 17:
		if Global.marisaHand >= 17 || Global.marisaHand > 21:
			break
		Global.marisaHand += randi_range(1,10)
		$Bartering/Blackjack/OpponentNb.text = str(Global.marisaHand)
		
	if Global.marisaHand == Global.playerHand:
		$Bartering/Blackjack/PlayerNb.text += " - Draw!"
		
	elif Global.marisaHand < Global.playerHand || Global.marisaHand > 21: 
		$Bartering/Blackjack/PlayerNb.text += " - Win!"
		Global.wager *= 1.5
		
	elif Global.marisaHand < Global.playerHand: 
		$Bartering/Blackjack/PlayerNb.text += " - Lose!"
		Global.wager *= 0.5
	$Bartering/Cashout.position = Vector2(900,268)

func checkBust():
	if Global.playerHand > 21:
		$Bartering/Blackjack/PlayerNb.text += " - Bust!"
		Global.wager *= 0.5
	elif Global.playerHand == 21:
		$Bartering/Blackjack/PlayerNb.text += " - Blackjack!"
		Global.wager *= 1.5
	elif $Bartering/Blackjack/DDown.disabled == true:
		_on_stand_pressed()
	$Bartering/Cashout.position = Vector2(900,268)

#Confirming a sale and updating the amount
func sell(total):
	Global.funds += total
	$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
	$Bartering/HigherLower.position = Vector2(9000,3000)
	$Bartering/Blackjack.position = Vector2(9000,3000)

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
	
	$Bartering/HigherLower/Card1.text = ""
	$Bartering/HigherLower/Card2.text = ""
	
	$CardSale/Labels/Xs.text = "Lesser ability cards " + str(Global.sold_xs) + "/" + str(Global.ability_card_xs)
	$CardSale/Labels/S.text = "Ability cards " + str(Global.sold_s) + "/" + str(Global.ability_card_s)
	$CardSale/Labels/M.text = "Greater ability cards " + str(Global.sold_m) + "/" + str(Global.ability_card_m)
	$CardSale/Labels/L.text = "Quest ability cards " + str(Global.sold_l) + "/" + str(Global.ability_card_l)
	$CardSale/Labels/Xl.text = "Special ability cards " + str(Global.sold_xl) + "/" + str(Global.ability_card_xl)

#Variables for the higher-lower minigame
func _on_higher_pressed() -> void:
	$Bartering/HigherLower/Card2.text = str(Global.nb2)
	if Global.nb1 < Global.nb2:
		Global.wager *= 1.25
		$Bartering/HigherLower/Card2.text += ": Win!"
	elif Global.nb1 > Global.nb2:
		Global.wager *= 0.75
		$Bartering/HigherLower/Card2.text += ": Lose!"
	$Bartering/Cashout.position = Vector2(900,268)

func _on_lower_pressed() -> void:
	$Bartering/HigherLower/Card2.text = str(Global.nb2)
	if Global.nb1 > Global.nb2:
		Global.wager *= 1.25
		$Bartering/HigherLower/Card2.text += ": Win!"
	elif Global.nb1 < Global.nb2:
		Global.wager *= 0.75
		$Bartering/HigherLower/Card2.text += ": Lose!"
	$Bartering/Cashout.position = Vector2(900,268)

#Ends the bartering process
func _on_cashout_pressed() -> void:
	remove_stock()
	sell(ceili(Global.wager))
	$Bartering/Cashout.position = Vector2(9000,3000)
	$Bartering/Blackjack/Hit.disabled = false
	$Bartering/Blackjack/Stand.disabled = false
	$Bartering/Blackjack/DDown.disabled = false
