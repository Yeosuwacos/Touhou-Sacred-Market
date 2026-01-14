extends Node2D

#Readies the mine layout
@onready var mine = []
@onready var chimataLocation = [50,0]
@onready var locationX = 0
@onready var locationY = 0
@onready var tilemap = get_node("mineWindow/oreMap")
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")
@onready var chimata = chimataScene.instantiate()
@export var ores : Array[Ores]
@export var noiseMaker : FastNoiseLite

#Sets the amount of utilities 
@onready var bombs = Global.bombQty
@onready var tps = Global.tpQty
@onready var mults = Global.multQty

func _ready():
	#Sets the isMining flag to true
	Global.isMining = true
	
	#Loads Chimata in the right spot
	add_child(chimata)
	chimata.position = Vector2((chimataLocation[0]*128+32),(chimataLocation[1]*128+64))
	
	#Makes the camera and the move counter follow chimata
	Global.follow = true
	#$mineWindow/moveCounter.position = Vector2((chimataLocation[0]*128+832),(chimataLocation[1]*128-464))
	
	#Creates the mine as a 2D grid
	#Places down every tile correctly
	noiseMaker.seed = randi()
	
	for i in 100:
		mine.append([])
		for j in 500:
			mine[i].append(0)
			tilemap.set_cell(Vector2i(i, j), 1, Vector2i(0, 0))
	
	#Goes through the mine again to place down the ores
	for i in 100:
		for j in 500:
			var pos = Vector2i(i,j)
			var noise = noiseMaker.get_noise_2d(i*0.1,j*0.1)
			noise = (noise+1)/2
			
			for ore in ores:
				if ore.minimum <= j && j <= ore.maximum && noise > ore.chance && randf() < 0.03:
					placeOres(pos,ore.type)
			
	#Places Chimata at the top of the mine
	tilemap.set_cell(Vector2i(50, 0), -1)
	mine[50][0] = 0
	
#Makes an inventory for all ores collected
@onready var ore_xs = 0
@onready var ore_s = 0
@onready var ore_m = 0
@onready var ore_l = 0
@onready var ore_xl = 0

#Calculates the amount of moves Chimata is allowed to do
@onready var moves = Global.moves

#Generates clumps of ores (flood fill algorithm)
func placeOres(startPos: Vector2i, type: int):
	var size = randi_range(1,12)
	
	var unfinished = [startPos]
	var finished = {}
	
	while unfinished.size() > 0 && size > 0:
		var pos = unfinished.pop_front()
		if pos.x < 0 || pos.x >= 100 || pos.y < 0 || pos.y >= 500:
			continue
		if finished.has(pos):
			continue
		if mine[pos.x][pos.y] != 0:
			continue
		tilemap.set_cell(pos, 1, Vector2i(type, 0))
		mine[pos.x][pos.y] = type
		finished[pos] = true
		size -= 1
		
		#Looks around the tile to generate veins
		unfinished.append(pos + Vector2i(1,0))
		unfinished.append(pos + Vector2i(0,1))
		unfinished.append(pos + Vector2i(-1,0))
		unfinished.append(pos + Vector2i(0,-1))

#Detects where Chimata is going to check which ore she picks up
#Removes the ore from the mine
#Uses special items if needed

func _physics_process(delta):
	#Manages the boundaries
	if chimataLocation[0] <= 0:
		Global.maxLEFT = false
	else:
		Global.maxLEFT = true
		
	if chimataLocation[0] >= 100:
		Global.maxRIGHT = false
	else:
		Global.maxRIGHT = true
		
	if chimataLocation[1] <= 0:
		Global.maxUP = false
	else:
		Global.maxUP = true
		
	if chimataLocation[1] >= 500:
		Global.maxDOWN = false
	else:
		Global.maxDOWN = true
	
	#Makes sure that you cant go out of bounds
	if moves > 0 && Global.isMining == true:
		#Move counter
		$mineWindow/Labels/moveCounter.text = str(moves) + " moves"
		
		if Input.is_action_just_pressed("walkLeft"):
			if chimataLocation[0] > 0:
				chimataLocation[0] -= 1
				updateLocation()
				mineTile(0,0,Global.addActive)
			
		if Input.is_action_just_pressed("walkRight"):
			if chimataLocation[0] < 100:
				chimataLocation[0] += 1
				updateLocation()
				mineTile(0,0,Global.addActive)
			
		if Input.is_action_just_pressed("walkDown"):
			if chimataLocation[1] < 500:
				chimataLocation[1] += 1
				updateLocation()
				mineTile(0,0,Global.addActive)
			
		if Input.is_action_just_pressed("walkUp"):
			if chimataLocation[1] > 0:
				chimataLocation[1] -= 1
				updateLocation()
				mineTile(0,0,Global.addActive)
			
		#Special actions
		if Input.is_action_just_pressed("bomb"):
			#Makes sure the bomb explosion is within range of the map
			if bombs > 0 && chimataLocation[1] > Global.bombStr:
				for i in range(1-Global.bombStr,Global.bombStr):
					for j in range(1-Global.bombStr,Global.bombStr):
						mineTile(i,j,Global.addActive)
				bombs -= 1
				
		if Input.is_action_just_pressed("tp"):
			#Make sure Chimata does not tp out of bounds
			if tps > 0 && (chimataLocation[1] + Global.tpStr) < 500:
				chimataLocation[1] += Global.tpStr
				updateLocation()
				mineTile(0,0,Global.addActive)
				chimata.position.y += 128*Global.tpStr
				tps -= 1
				
		if Input.is_action_just_pressed("addStr"):
			if mults > 0:
				Global.addActive = true
				mults -= 1
	#Brings up the minigame end screen (stats and button)
	elif moves == 0:
		endGame()
		
#Executes multiple mining operations
func mineTile(offsetX,offsetY,mult):
	add_ore(mine[locationX+offsetX][locationY+offsetY],mult)
	mine[locationX+offsetX][locationY+offsetY] = 0
	tilemap.set_cell(Vector2i(locationX+offsetX,locationY+offsetY),-1)

#Updates chimata's current location
#Decrements the amount of moves Chimata has
func updateLocation():
	locationX = chimataLocation[0]
	locationY = chimataLocation[1]
	moves -= 1

#Adds the corresponding ore and multiplier
func add_ore(nb,mult):
	var strength = 1
	if mult == true:
		strength = Global.multStr
		
	match nb:
		1: ore_xs += strength
		2: ore_s += strength
		3: ore_m += strength
		4: ore_l += strength
		5: ore_xl += strength
		
	Global.addActive = false

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

#Ends the mining game early
func _on_back_early_pressed() -> void:
	endGame()

#Displays statistics and offers to go back to the surface
func endGame():
	Global.isMining = false
	#Removes move counter 
	$mineWindow/Labels/moveCounter.text = ""
	
	#Displays surface
	$mineWindow/Labels/returnSurface.visible = true
	$mineWindow/Labels/returnSurface/Stats.text = "You mined:\r" + str(ore_xs) + " dragon gem dust\r" \
	+ str(ore_s) + " dragon gem pieces\r" + str(ore_m) + " dragon gems\r" + str(ore_l) \
	+ " dragon gem chunks\r" + str(ore_xl) + " dragon gem clusters" 
