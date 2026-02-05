extends Node2D

#Readies the mine layout
@onready var mine = []
@onready var tilemap = get_node("mineWindow/oreMap")
@onready var chimataScene = preload("res://entities/characters/chimata.tscn")
@onready var chimata = chimataScene.instantiate()
@onready var cooldown = 0.2
@export var ores : Array[Ores]
@export var noise : FastNoiseLite
const tileSize := 128
var start = Vector2i(100,0)

#Sets the amount of utilities 
@onready var bombs = Global.bombQty
@onready var tps = Global.tpQty
@onready var mults = Global.multQty
@onready var frenzies = Global.frenzyQty

#Calculates the amount of moves Chimata is allowed to do
@onready var moves = Global.moves 

func _ready():
	#Sets the isMining flag to true
	Global.isMining = true
	
	#Loads Chimata in the right spot
	chimata.position = Vector2(start.x*tileSize + tileSize/2, start.y*tileSize + tileSize/2)
	add_child(chimata)
	
	#Makes the camera and the move counter follow chimata
	Global.follow = true
	
	#Places the UI
	$mineWindow/Labels/ResourceBarsLeft.position.y = get_viewport_rect().size.y - $mineWindow/Labels/ResourceBarsLeft.size.y
	$mineWindow/Labels/ResourceBarsRight.position.y = get_viewport_rect().size.y - $mineWindow/Labels/ResourceBarsRight.size.y
	$mineWindow/Labels/ResourceBarsRight.position.x = get_viewport_rect().size.x - $mineWindow/Labels/ResourceBarsRight.size.x
	$mineWindow/Labels/ResourceBarsCenter.position.y = get_viewport_rect().size.y - $mineWindow/Labels/ResourceBarsCenter.size.y
	$mineWindow/Labels/ResourceBarsCenter.position.x = get_viewport_rect().size.x/2 - $mineWindow/Labels/ResourceBarsCenter.size.x/2
	
	$mineWindow/Labels/ResourceBarsLeft/MultStrLeft.value = mults
	if mults != 0:
		$mineWindow/Labels/ResourceBarsLeft/MultStrLeft.max_value = mults
		
	$mineWindow/Labels/ResourceBarsLeft/BombsLeft.value = bombs
	if bombs != 0:
		$mineWindow/Labels/ResourceBarsLeft/BombsLeft.max_value = bombs
		
	$mineWindow/Labels/ResourceBarsRight/TPsLeft.value = tps
	if tps != 0:
		$mineWindow/Labels/ResourceBarsRight/TPsLeft.max_value = tps
		
	$mineWindow/Labels/ResourceBarsRight/FrenziesLeft.value = frenzies
	if frenzies != 0:
		$mineWindow/Labels/ResourceBarsRight/FrenziesLeft.max_value = frenzies
	
	#Creates the mine as a 2D grid
	#Places down every tile correctly and generates the caverns
	
	for i in 200:
		mine.append([])
		for j in 500:
			if solidTile(noise.get_noise_2d(i,j)):
				mine[i].append(0)
				tilemap.set_cell(Vector2i(i, j), 1, Vector2i(0, 0))
			else:
				mine[i].append(-1)
	
	#Goes through the mine again to place down the ores
	for i in 200:
		mine.append([])
		for j in 500:
			var pos = Vector2i(i,j)
			
			for ore in ores:
				if ore.minimum <= j && j <= ore.maximum && randf() < 0.025*ore.chance:
					placeOres(pos,ore.type)

	#Places Chimata at the top of the mine
	tilemap.set_cell(start, -1)
	mine[50][0] = 0
	
#Makes an inventory for all ores collected
@onready var ore_xs = 0
@onready var ore_s = 0
@onready var ore_m = 0
@onready var ore_l = 0
@onready var ore_xl = 0

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

#Checks if the tile should exist based on the caverns
func solidTile(noise):
	if noise <= -0.15:
		return false
	return true
	
#Gets the current tile Chimata is on
func getTile():
	return Vector2i(int(chimata.position.x/128), int(chimata.position.y/128))

#Gets the tile Chimata is hovering on
func hoverTile():
	return Vector2i(chimata.position.x/tileSize + direct().x,chimata.position.y/tileSize + direct().y)
#Turns Chimata's orientation into an axis
func direct():
	var orient = chimata.orient
	if abs(orient.x) > abs(orient.y):
		return Vector2i(sign(orient.x),0)
	else:
		return Vector2i(0,sign(orient.y))

#Detects where Chimata is going to check which ore she picks up
#Removes the ore from the mine
#Uses special items if needed

func _physics_process(delta):
	if cooldown < 0.2:
		cooldown += delta
	if moves <= 0 || Global.isMining == false:
		return
	var chimataPos = getTile()
	
	#Movement
	var input_dir = Vector2(
	Input.get_action_strength("walkRight") - Input.get_action_strength("walkLeft"),
	Input.get_action_strength("walkDown") - Input.get_action_strength("walkUp")
	)

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		chimata.orient = input_dir

	chimata.velocity.x = input_dir.x * chimata.speed

	if Global.isMining:
		chimata.velocity.y += chimata.gravity * delta
	else:
		chimata.velocity.y = 0
		
	if Input.is_action_just_pressed("walkUp") && chimata.is_on_floor():
		chimata.velocity.y = -600

	chimata.move_and_slide()
	
	#Mining
	if Input.is_action_pressed("confirm") && cooldown >= 0.2:
		cooldown = 0.0
		var target = hoverTile()
		if mineTile(target,Global.addActive):
			moves -= 1
			$mineWindow/Labels/ResourceBarsCenter.size.x -= $mineWindow/Labels/ResourceBarsCenter.size.x/moves
			$mineWindow/Labels/ResourceBarsCenter.position.x = get_viewport_rect().size.x/2 - $mineWindow/Labels/ResourceBarsCenter.size.x/2
	#Special actions
	if Input.is_action_just_pressed("bomb") && bombs > 0:
		var bombSignal = false
		for i in range(-Global.bombStr+1,Global.bombStr):
			for j in range(-Global.bombStr+1, Global.bombStr):
				var pos = chimataPos + Vector2i(i,j)
				if mineTile(pos, Global.addActive) == true:
					bombSignal = true
					mineTile(pos, Global.addActive)
		if bombSignal == true:
			bombs -= 1
			moves -= 1
			$mineWindow/Labels/ResourceBarsLeft/BombsLeft.value -= 1
			
	if Input.is_action_just_pressed("tp") && tps > 0:
		var y = chimataPos.y + Global.tpStr
		if y < 500:
			mineTile(Vector2i(chimataPos.x,chimataPos.y + Global.tpStr + 1),Global.addActive)
			tps -= 1
			moves -= 1
			chimata.position.y += tileSize*Global.tpStr
			$mineWindow/Labels/ResourceBarsRight/TPsLeft.value -= 1
			
	if Input.is_action_just_pressed("addStr") && mults > 0 && Global.addActive == false:
		Global.addActive = true
		mults -= 1
		$mineWindow/Labels/ResourceBarsLeft/MultStrLeft.value -= 1
			
	if Input.is_action_just_pressed("frenzy") && frenzies > 0:
		var y = chimataPos.y + Global.frenzyStr
		if y < 500:
			for depth in range(Global.frenzyStr):
				mineTile(Vector2i(chimataPos.x - 1, chimataPos.y + depth), Global.addActive)
				mineTile(Vector2i(chimataPos.x, chimataPos.y + depth), Global.addActive)
				mineTile(Vector2i(chimataPos.x + 1, chimataPos.y + depth), Global.addActive)
			frenzies -= 1
			moves -= 1
			$mineWindow/Labels/ResourceBarsRight/FrenziesLeft.value -= 1
	#Brings up the minigame end screen (stats and button)
	if moves <= 0:
		endGame()
		
#Executes multiple mining operations
func mineTile(pos,mult):
	#Boundaries
	pos.x = clamp(pos.x,0,199)
	pos.y = clamp(pos.y,0,499)
	
	#Mines the tile depending on value
	var tileVal = mine[pos.x][pos.y]
	if tileVal == -1:
		return false
	else:
		addOre(tileVal,mult)
		mine[pos.x][pos.y] = -1
		tilemap.set_cell(pos,-1)
		return true

#Adds the corresponding ore and multiplier
func addOre(nb,mult):
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
	
	#Displays surface
	$mineWindow/Labels/returnSurface.visible = true
	$mineWindow/Labels/returnSurface/Stats.text = "You mined:\r" + str(ore_xs) + " dragon gem dust\r" \
	+ str(ore_s) + " dragon gem pieces\r" + str(ore_m) + " dragon gems\r" + str(ore_l) \
	+ " dragon gem chunks\r" + str(ore_xl) + " dragon gem clusters" 

func _exit_tree():
	Save.saveGame()
