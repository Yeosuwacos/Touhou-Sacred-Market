extends Node2D

#Readies the mine layout
@onready var mine = []
@onready var chimataLocation = [50,0]
@onready var locationX = 0
@onready var locationY = 0
@onready var tilemap = get_node("mineWindow/oreMap")
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")

#Sets the amount of utilities 
@onready var bombs = Global.bombQty
@onready var tps = Global.tpQty
@onready var adds = Global.addQty

func _ready():
	#Sets the isMining flag to true
	Global.isMining = true
	
	#Loads Chimata in the right spot
	var chimata = chimataScene.instantiate()
	add_child(chimata)
	chimata.position = Vector2((chimataLocation[0]*128+32),(chimataLocation[1]*128+64))
	
	#Makes the camera and the move counter follow chimata
	Global.follow = true
	#$mineWindow/moveCounter.position = Vector2((chimataLocation[0]*128+832),(chimataLocation[1]*128-464))
	
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
				tps -= 1
				
		if Input.is_action_just_pressed("addStr"):
			if adds > 0:
				Global.addActive = true
				adds -= 1
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
		strength = Global.addStr
		
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
