extends VBoxContainer

#Prepares the shop for when it is opened
func _ready():
	
	$ShopGrid/SpecialUpgradesText.text = "Special upgrades"
	
	#UI
	$GUI.position.y = $ShopGrid.size.y
	$GUI/Funds.text = str(floori(Global.funds))
