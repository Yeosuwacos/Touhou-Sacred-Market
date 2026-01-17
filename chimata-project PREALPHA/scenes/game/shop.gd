extends Node2D

#Prepares the shop for when it is opened
func _ready():
	$ShopGrid/MovesText.text = "+25  moves: " + str(floori(Prices.MoreMoves))
	
	if Global.multQty == 10:
		$ShopGrid/MultText.text = "+1 ore multiplier: MAX"
	else:
		$ShopGrid/MultText.text = "+1 ore multiplier: " + str(floori(Prices.MoreMoves))
	$ShopGrid/MultStrText.text = "+1 multiplier strength: " + str(floori(Prices.Mult))
	
	if Global.bombQty == 10:
		$ShopGrid/BombsText.text = "+ 1 bomb: MAX"
	else:
		$ShopGrid/BombsText.text = "+1 bomb: " + str(floori(Prices.MoreBombs))
	$ShopGrid/BombPowerText.text = "+Bomb power: " + str(floori(Prices.BombPower))
	
	if Global.tpQty == 10:
		$ShopGrid/TPsText.text = "+1 teleport: MAX"
	else:
		$ShopGrid/TPsText.text = "+1 teleport: " + str(floori(Prices.MoreTPs))
	$ShopGrid/TPpowerText.text = "+5 teleport power: " + str(floori(Prices.TPpower))
	
	if Global.frenzyQty == 10:
		$ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: MAX"
	else:
		$ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: " + str(floori(Prices.Frenzy))
	$ShopGrid/FrenzyPowerText.text = "+3 frenzy power: " + str(floori(Prices.FrenzyPwr))
	
	$GUI.position.y = $ShopGrid.size.y
	
	$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more moves
func _on_moves_pressed() -> void:
	if Global.funds >= Prices.MoreMoves:
		Global.funds -= Prices.MoreMoves
		Global.moves += 25
		Prices.MoreMovesBought += 1
		Prices.MoreMoves += 50*Prices.MoreMovesBought**1.2
		$ShopGrid/MovesText.text = "+25 moves: " + str(floori(Prices.MoreMoves))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more multipliers
func _on_mult_pressed() -> void:
	if Global.funds >= Prices.Mult && Global.multQty < 10:
		Global.funds -= Prices.Mult
		Global.multQty += 1
		Prices.MultBought += 1
		Prices.Mult += 50*Prices.MultBought**1.7
		
		if Global.multQty == 10:
			$ShopGrid/MultText.text = "+1 ore multiplier: MAX"
		else:
			$ShopGrid/MultText.text = "+1 ore multiplier: " + str(floori(Prices.Mult))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
		
#Increases multiplier strength
func _on_mult_str_pressed() -> void:
	if Global.funds >= Prices.MultStr:
		Global.funds -= Prices.MultStr
		Global.multStr += 1
		Prices.MultStrBought += 1
		Prices.MultStr += 100*Prices.MultStrBought**1.2
		$ShopGrid/MultStrText.text = "+1 multiplier strength: " + str(floori(Prices.MultStr))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more bombs
func _on_bombs_pressed() -> void:
	if Global.funds >= Prices.MoreBombs && Global.bombQty < 10:
		Global.funds -= Prices.MoreBombs
		Global.bombQty += 1
		Prices.MoreBombsBought += 1
		Prices.MoreBombs += 100*Prices.MoreBombsBought**1.4
		
		if Global.bombQty == 10:
			$ShopGrid/BombsText.text = "+1 bomb: MAX"
		else:
			$ShopGrid/BombsText.text = "+1 bomb: " + str(floori(Prices.MoreBombs))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Increases bomb power
func _on_bomb_power_pressed() -> void:
	if Global.funds >= Prices.BombPower:
		Global.funds -= Prices.BombPower
		Global.bombStr += 1
		Prices.BombPowerBought += 1
		Prices.BombPower += 500*Prices.BombPowerBought**1.6
		$ShopGrid/BombPowerText.text = "+Bomb power: " + str(floori(Prices.BombPower))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more TPs
func _on_t_ps_pressed() -> void:
	if Global.funds >= Prices.MoreTPs && Global.tpQty < 10:
		Global.funds -= Prices.MoreTPs
		Global.tpQty += 1
		Prices.MoreTPsBought += 1
		Prices.MoreTPs += 200*Prices.MoreTPsBought**1.3
		
		if Global.tpQty == 10:
			$ShopGrid/TPsText.text = "+1 teleport: MAX"
		else:
			$ShopGrid/TPsText.text = "+1 teleport: " + str(floori(Prices.MoreTPs))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Increases TP power
func _on_t_ppower_pressed() -> void:
	if Global.funds >= Prices.TPpower:
		Global.funds -= Prices.TPpower
		Global.tpStr += 5
		Prices.TPpowerBought += 1
		Prices.TPpower += 300*Prices.TPpowerBought**1.5
		$ShopGrid/TPpowerText.text = "+5 teleport power: " + str(floori(Prices.TPpower))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Adds more frenzies
func _on_momoyo_frenzy_pressed() -> void:
	if Global.funds >= Prices.Frenzy && Global.frenzyQty < 10:
		Global.funds -= Prices.Frenzy
		Global.frenzyQty += 1
		Prices.FrenzyBought += 1
		Prices.Frenzy += 250*Prices.FrenzyBought**1.35
		if Global.frenzyQty == 10:
			$ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: MAX"
		else:
			$ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: " + str(floori(Prices.Frenzy))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Increases frenzy power
func _on_frenzy_power_pressed() -> void:
	if Global.funds >= Prices.FrenzyPwr:
		Global.funds -= Prices.FrenzyPwr
		Global.frenzyStr += 3
		Prices.FrenzyPwrBought += 1
		Prices.FrenzyPwr += 400*Prices.FrenzyPwrBought**1.4
		$ShopGrid/FrenzyPowerText.text = "+3 frenzy power: " + str(floori(Prices.FrenzyPwr))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
