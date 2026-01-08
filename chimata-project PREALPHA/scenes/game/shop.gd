extends Node2D

#Prepares the shop for when it is opened
func _ready():
	$ShopGrid/MovesText.text = "+10 moves: " + str(floori(Prices.MoreMoves))
	$ShopGrid/BombsText.text = "+1 bomb: " + str(floori(Prices.MoreBombs))
	$ShopGrid/BombPowerText.text = "+Bomb power: " + str(floori(Prices.BombPower))
	$ShopGrid/TPsText.text = "+1 teleport: " + str(floori(Prices.MoreTPs))
	$GUI.position.y = $ShopGrid.size.y
	$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more moves
func _on_moves_pressed() -> void:
	if Global.funds >= Prices.MoreMoves:
		Global.funds -= Prices.MoreMoves
		Global.moves += 10
		Prices.MoreMovesBought += 1
		Prices.MoreMoves += 10*Prices.MoreMovesBought**1.5
		$ShopGrid/MovesText.text = "+10 moves: " + str(floori(Prices.MoreMoves))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more bombs
func _on_bombs_pressed() -> void:
	if Global.funds >= Prices.MoreBombs:
		Global.funds -= Prices.MoreBombs
		Global.bombQty += 1
		Prices.MoreBombsBought += 1
		Prices.MoreBombs += 100*Prices.MoreBombsBought**1.6
		$ShopGrid/BombsText.text = "+1 bomb: " + str(floori(Prices.MoreBombs))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Increases bomb power
func _on_bomb_power_pressed() -> void:
	if Global.funds >= Prices.BombPower:
		Global.funds -= Prices.BombPower
		Global.bombStr += 1
		Prices.BombPower += 500*Global.bombStr**3
		$ShopGrid/BombPowerText.text = "+Bomb power: " + str(floori(Prices.BombPower))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))

#Buys more TPs
func _on_t_ps_pressed() -> void:
	if Global.funds >= Prices.MoreTPs:
		Global.funds -= Prices.MoreTPs
		Global.tpQty += 1
		Prices.MoreTPsBought += 1
		Prices.MoreTPs += 200*Prices.MoreTPsBought**1.9
		$ShopGrid/TPsText.text = "+1 teleport: " + str(floori(Prices.MoreTPs))
		$GUI/Funds.text = "Funds: " + str(floori(Global.funds))
