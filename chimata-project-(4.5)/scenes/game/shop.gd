extends Node2D

#Prepares the shop for when it is opened
func _ready():
	$ShopGrid/MovesText.text = "+25 stamina: " + str(floori(Prices.MoreMoves))
	
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
	
	$GUI/Funds.text = str(floori(Global.funds))
