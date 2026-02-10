extends Node2D

#Prepares the idle shop for when it is opened
func _ready():
	$IdleShopGrid/idlerXsText.text = "+1 dust gatherer: " + str(floori(Prices.idleXs))
	$IdleShopGrid/idlerSText.text = "+1 ore gatherer: " + str(floori(Prices.idleS))
	$IdleShopGrid/idlerMText.text = "+1 gem gatherer: " + str(floori(Prices.idleM))
	$IdleShopGrid/idlerLText.text = "+1 chunk gatherer: " + str(floori(Prices.idleL))
	$IdleShopGrid/idlerXlText.text = "+1 cluster gatherer: " + str(floori(Prices.idleXl))
