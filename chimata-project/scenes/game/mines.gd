extends Node2D

@onready var chimataScene = preload("res://entities/characters/chimata.tscn")

func _ready():
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2(900,300)
