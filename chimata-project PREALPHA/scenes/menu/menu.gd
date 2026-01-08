extends Control

#Developer mode (variable modification)

func _ready():
	$DevMode/Resources.visible = false

func _on_access_pressed() -> void:
	if $DevMode/Password.text == "LuvChimata<3":
		$DevMode/Resources.visible = true
		
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
