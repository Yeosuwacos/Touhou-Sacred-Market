extends Node2D

@onready var chimataScene = preload("res://entities/characters/chimata.tscn")

func _ready():
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2i(Global.res.x-50,300)

#Opens the mine shop
func _on_shop_button_pressed() -> void:
	if Global.mShopOpen == false:
		$Shop.position = Vector2(Global.res.x/2,Global.res.y/2)
		Global.mShopOpen = true
		
	elif Global.mShopOpen == true:
		$Shop.position = Vector2(9000,3000)
		Global.mShopOpen = false
