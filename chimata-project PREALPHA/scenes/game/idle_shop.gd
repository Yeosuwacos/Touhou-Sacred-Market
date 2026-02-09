extends Node2D

#Prepares the idle shop for when it is opened
func _ready():
	$IdleShopGrid/idlerXsText.text = "+1 xs/s: " + str(floori(Prices.idleXs))
	$IdleShopGrid/idlerSText.text = "+1 s/s: " + str(floori(Prices.idleS))
	$IdleShopGrid/idlerMText.text = "+1 m/s " + str(floori(Prices.idleM))
	$IdleShopGrid/idlerLText.text = "+1 l/s " + str(floori(Prices.idleL))
	$IdleShopGrid/idlerXlText.text = "+1 xl/s " + str(floori(Prices.idleXl))
