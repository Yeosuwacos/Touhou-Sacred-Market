extends GridContainer

#Prepares the idle shop for when it is opened
func _ready():
	$idlerXsText.text = "+1 xs/s: " + str(floori(Prices.idleXs))
	
#Buys idle harvesters
func _on_idler_xs_pressed() -> void:
	if Global.funds >= Prices.idleXs:
		Global.funds -= Prices.idleXs
		Global.idleXs += 1
		Prices.idleXsBought += 1
		Prices.idleXs += 100*Prices.idleXsBought**1.6
		$idlerXsText.text = "+1 xs/s: " + str(floori(Prices.idleXs))
