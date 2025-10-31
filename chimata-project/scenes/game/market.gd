extends Node2D

#Preloading Chimata

@onready var chimataScene = preload("res://entities/characters/chimata.tscn")

func _ready():
	
	#When loaded, place chimata down on x,y
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2(500,300)
