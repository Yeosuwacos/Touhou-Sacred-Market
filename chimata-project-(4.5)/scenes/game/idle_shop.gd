extends Node2D

#Prepares the idle shop for when it is opened
func _ready():
	$IdleShopGrid/idlerXsText.text = "+1 xs/s: " + str(floori(Prices.idleXs))
	$IdleShopGrid/idlerSText.text = "+1 s/s: " + str(floori(Prices.idleS))
	
#Buys idle harvesters
func _on_idler_xs_pressed() -> void:
	if Global.funds >= Prices.idleXs:
		Global.funds -= Prices.idleXs
		Global.idleXs += 1
		Prices.idleXsBought += 1
		Prices.idleXs += 100*Prices.idleXsBought**1.6
		$IdleShopGrid/idlerXsText.text = "+1 xs/s: " + str(floori(Prices.idleXs))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

func _on_idler_s_pressed() -> void:
	if Global.funds >= Prices.idleS:
		Global.funds -= Prices.idleS
		Global.idleS += 1
		Prices.idleSBought += 1
		Prices.idleS += 150*Prices.idleSBought**2
		$IdleShopGrid/idlerSText.text = "+1 s/s: " + str(floori(Prices.idleS))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
