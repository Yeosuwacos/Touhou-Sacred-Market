extends Node2D

#Readies the mine layout
@onready var mine = []
@onready var chimataLocation = [50,0]
@onready var locationX = 0
@onready var locationY = 0
@onready var tilemap = get_node("mineWindow/oreMap")
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")

func _ready():
	#Sets the isMining flag to true
	Global.isMining = true
	
	#Loads Chimata in the right spot
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2((chimataLocation[0]*128+32),(chimataLocation[1]*128+64))
	
	#Makes the camera and the move counter follow chimata
	Global.follow = true
	$mineWindow/moveCounter.position = Vector2((chimataLocation[0]*128+832),(chimataLocation[1]*128-464))
	
	#Creates the mine as a 2D grid
	#Adds values to each tile between 0 and 5
	#Places the right tile on the right area
	
	for i in 100:
		mine.append([])
		for j in 500:
			var rarity = roundi(randf_range(0,1) * (j/100)) + randi_range(0,1)
			rarity *= randi_range(0,1)
			mine[i].append(rarity)
			tilemap.set_cell(Vector2i(i,j),1,Vector2i(rarity,0))
			
	#Places Chimata at the top of the mine
	tilemap.set_cell(Vector2i(50,0),-1)
	mine[50][0] = 0
	
#Makes an inventory for all ores collected
@onready var ore_xs = 0
@onready var ore_s = 0
@onready var ore_m = 0
@onready var ore_l = 0
@onready var ore_xl = 0

#Calculates the amount of moves Chimata is allowed to do
@onready var moves = Global.moves

#Detects where Chimata is going to check which ore she picks up
#Removes the ore from the mine

func _physics_process(delta):
	#Move counter tag
	$mineWindow/moveCounter.text = str(moves) + " moves"
	$mineWindow/moveCounter.position = Vector2((chimataLocation[0]*128+832),(chimataLocation[1]*128-464))
	
	if moves > 0:
		if Input.is_action_just_pressed("walkLeft"):
			chimataLocation[0] -= 1
			updateLocation()
			mineTile()
			
		if Input.is_action_just_pressed("walkRight"):
			chimataLocation[0] += 1
			updateLocation()
			mineTile()
			
		if Input.is_action_just_pressed("walkDown"):
			chimataLocation[1] += 1
			updateLocation()
			mineTile()
			
		if Input.is_action_just_pressed("walkUp"):
			chimataLocation[1] -= 1
			updateLocation()
			mineTile()
			
	#Brings up the minigame end screen (stats and button)
	elif moves == 0:
		Global.isMining = false
		$mineWindow/returnSurface.position = Vector2((chimataLocation[0]*128-832),(chimataLocation[1]*128-464))
		
		$mineWindow/returnSurface/Stats.text = "You mined:\r" + str(ore_xs) + " dragon gem dust\r" \
		+ str(ore_s) + " dragon gem pieces\r" + str(ore_m) + " dragon gems\r" + str(ore_l) \
		+ " dragon gem chunks\r" + str(ore_xl) + " dragon gem clusters" 
		
#Executes multiple mining operations
func mineTile():
	add_ore(mine[locationX][locationY])
	mine[locationX][locationY] = 0
	tilemap.set_cell(Vector2i(locationX,locationY),-1)

#Updates chimata's current location
#Decrements the amount of moves Chimata has
func updateLocation():
	locationX = chimataLocation[0]
	locationY = chimataLocation[1]
	moves -= 1

#Adds the corresponding 
func add_ore(nb):
	if nb == 1:
		ore_xs += 1
	if nb == 2:
		ore_s += 1
	if nb == 3:
		ore_m += 1
	if nb == 4:
		ore_l += 1
	if nb == 5:
		ore_xl += 1

#Ends the mining session and returns to the surface
func _on_back_pressed() -> void:
	Global.follow = false
	#Updates ores available
	Global.dragon_gem_xs += ore_xs
	Global.dragon_gem_s += ore_s
	Global.dragon_gem_m += ore_m
	Global.dragon_gem_l += ore_l
	Global.dragon_gem_xl += ore_xl
	queue_free()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/mines.tscn")
