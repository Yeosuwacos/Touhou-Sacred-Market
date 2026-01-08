extends Control

#Developer mode (variable modification)

func _ready():
	$DevMode/Resources.visible = false
	if Global.passwordEntered == true:
		$DevMode/Resources.visible = true

func _on_access_pressed() -> void:
	if $DevMode/Password.text == "LuvChimata<3":
		$DevMode/Resources.visible = true
		Global.passwordEntered = true
		
#Adding resources

func _on_more_funds_add_pressed() -> void:
	Global.funds += 10000

func _on_lots_more_funds_add_pressed() -> void:
	Global.funds += 1000000

func _on_more_ores_add_pressed() -> void:
	Global.dragon_gem_xs += 1000
	Global.dragon_gem_s += 1000
	Global.dragon_gem_m += 1000
	Global.dragon_gem_l += 1000
	Global.dragon_gem_xl += 1000

func _on_more_cards_add_pressed() -> void:
	Global.ability_card_xs += 10
	Global.ability_card_s += 10
	Global.ability_card_m += 10
	Global.ability_card_l += 10
	Global.ability_card_xl += 10

#Resetting the game's progress
func _on_reset_rem_pressed() -> void:
	Global.dragon_gem_xs = 0
	Global.dragon_gem_s = 0
	Global.dragon_gem_m = 0
	Global.dragon_gem_l = 0
	Global.dragon_gem_xl = 0
	
	Global.ability_card_xs = 0
	Global.ability_card_s = 0
	Global.ability_card_m = 0
	Global.ability_card_l = 0
	Global.ability_card_xl = 0
	
	Global.funds = 0
	
	Global.sold_xs = 0
	Global.sold_s = 0
	Global.sold_m = 0
	Global.sold_l = 0
	Global.sold_xl = 0
	
	Global.moves = 20

	Global.bombStr = 2
	Global.bombQty = 1

	Global.tpStr = 5
	Global.tpQty = 1

	Global.addStr = 2
	Global.addQty = 1

	Global.idleXs = 0
	
	Prices.MoreMoves = 100
	Prices.MoreMovesBought = 0

	Prices.MoreBombs = 200
	Prices.MoreBombsBought = 0

	Prices.BombPower = 500

	Prices.idleXs = 1000
	Prices.idleXsBought = 0

#Reloads the current page with the correct variables
func _on_reload_pressed() -> void:
	get_parent().queue_free()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/market.tscn")
