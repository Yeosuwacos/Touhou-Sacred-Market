extends Area2D

var speed = 400
var type = ""

func set_hand_from_atlas(atlas_coords: Vector2i):
	var tex = AtlasTexture.new()
	tex.atlas = load("res://assets/game elements/directions.png")

	var tile_size = Vector2i(64,64)
	tex.region = Rect2(atlas_coords * tile_size,tile_size)

	$Hand.texture = tex

#Sets the hand texture
func _physics_process(delta):
	position -= transform.x * speed * delta
	match type:
		"up": set_hand_from_atlas(Vector2i(0,0))
		"down": set_hand_from_atlas(Vector2i(1,0))
		"right": set_hand_from_atlas(Vector2i(2,0))
		"left": set_hand_from_atlas(Vector2i(3,0))
