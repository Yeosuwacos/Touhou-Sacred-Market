extends Node2D

#Prepares the shop for when it is opened
func _ready():
	$ShopGrid/MovesText.text = "+25 stamina: " + str(floori(Prices.MoreMoves))
	
	$ShopGrid/SpecialUpgradesText.text = "Special upgrades"
	
	if Prices.MultBought >= 10:
		$ShopGrid/MultText.text = "+1 ore multiplier: MAX"
	else:
		$ShopGrid/MultText.text = "+1 ore multiplier: " + str(floori(Prices.MoreMoves))
	
	if Prices.MultStrBought >= 10:
		$ShopGrid/MultStrText.text = "+1 multiplier strength: MAX" 
	else:
		$ShopGrid/MultStrText.text = "+1 multiplier strength: " + str(floori(Prices.Mult))
	
	if Prices.MoreBombsBought >= 5:
		$ShopGrid/BombsText.text = "+ 1 bomb: MAX"
	else:
		$ShopGrid/BombsText.text = "+1 bomb: " + str(floori(Prices.MoreBombs))
		
	if Prices.BombPowerBought >= 5:
		$ShopGrid/BombPowerText.text = "+Bomb power: MAX"
	else:
		$ShopGrid/BombPowerText.text = "+Bomb power: " + str(floori(Prices.BombPower))
	
	if Prices.MoreTPsBought >= 5:
		$ShopGrid/TPsText.text = "+1 teleport: MAX"
	else:
		$ShopGrid/TPsText.text = "+1 teleport: " + str(floori(Prices.MoreTPs))
	
	if Prices.TPpowerBought >= 10:
		$ShopGrid/TPpowerText.text = "+5 teleport power: MAX"
	else:
		$ShopGrid/TPpowerText.text = "+5 teleport power: " + str(floori(Prices.TPpower))
	
	if Prices.FrenzyBought >= 5:
		$ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: MAX"
	else:
		$ShopGrid/MomoyoFrenzyText.text = "+1 frenzy: " + str(floori(Prices.Frenzy))
	
	if Prices.FrenzyPwrBought >= 5:
		$ShopGrid/FrenzyPowerText.text = "+3 frenzy power: MAX"
	else:
		$ShopGrid/FrenzyPowerText.text = "+3 frenzy power: " + str(floori(Prices.FrenzyPwr))
	
	$GUI.position.y = $ShopGrid.size.y
	
	$GUI/Funds.text = str(floori(Global.funds))
