extends Node2D

#On quit
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveGame()
		get_tree().quit()

#Saving the game
func saveGame():
	var path = "user://save.dat"
	
	var savedElements = {
		
		#Global variables
		"res" : Global.res,
		"gameSize" : Global.gameSize,
		"charaSize" : Global.charaSize,
		
		"passwordEntered" : Global.passwordEntered,
		
		"moves" : Global.moves,
		
		"bombStr" : Global.bombStr,
		"bombQty" : Global.bombQty,
		
		"tpStr" : Global.tpStr,
		"tpQty" : Global.tpQty,
		
		"multStr" : Global.multStr,
		"multQty" : Global.multQty,
		
		"frenzyStr" : Global.frenzyStr,
		"frenzyQty" : Global.frenzyQty,
		
		"idleXs" : Global.idleXs,
		"idleS" : Global.idleS,

		"sold_xs" : Global.sold_xs,
		"sold_s" : Global.sold_s,
		"sold_m" : Global.sold_m,
		"sold_l" : Global.sold_l,
		"sold_xl" : Global.sold_xl,

		"dragon_gem_xs" : Global.dragon_gem_xs,
		"dragon_gem_s" : Global.dragon_gem_s,
		"dragon_gem_m" : Global.dragon_gem_m,
		"dragon_gem_l" : Global.dragon_gem_l,
		"dragon_gem_xl" : Global.dragon_gem_xl,

		"ability_card_xs" : Global.ability_card_xs,
		"ability_card_s" : Global.ability_card_s,
		"ability_card_m" : Global.ability_card_m,
		"ability_card_l" : Global.ability_card_l,
		"ability_card_xl" : Global.ability_card_xl,

		"funds" : Global.funds,
		
		#Price variables
		"MoreMoves" : Prices.MoreMoves,
		"MoreMovesBought" : Prices.MoreMovesBought,

		"Mult" : Prices.Mult,
		"MultBought" : Prices.MultBought,

		"MultStr" : Prices.MultStr,
		"MultStrBought" : Prices.MultStrBought,

		"MoreBombs" : Prices.MoreBombs,
		"MoreBombsBought" : Prices.MoreBombsBought,

		"BombPower" : Prices.BombPower,
		"BombPowerBought" : Prices.BombPowerBought,

		"MoreTPs" : Prices.MoreTPs,
		"MoreTPsBought" : Prices.MoreTPsBought,

		"TPpower" : Prices.TPpower,
		"TPpowerBought" : Prices.TPpowerBought,
		
		"Frenzy" : Prices.Frenzy,
		"FrenzyBought" : Prices.FrenzyBought,
		
		"FrenzyPwr" : Prices.FrenzyPwr,
		"FrenzyPwrBought" : Prices.FrenzyPwrBought,

		"idleXsPrice" : Prices.idleXs,
		"idleXsBought" : Prices.idleXsBought,

		"idleSPrice" : Prices.idleS,
		"idleSBought" : Prices.idleSBought
		}
		
	var savefile = FileAccess.open(path,FileAccess.WRITE)
	
	if savefile == null:
		return
	
	savefile.store_var(savedElements)
	savefile.close()
	
#Loading the game
func loadGame():
	var path = "user://save.dat"
	
	if not FileAccess.file_exists(path):
		loadDefault()
	
	var savefile = FileAccess.open(path,FileAccess.READ)
	var loaded = savefile.get_var()
	savefile.close()
	
	#Loading global variables
	Global.res = loaded.get("res")
	Global.gameSize = loaded.get("gameSize")
	Global.charaSize = loaded.get("charaSize")

	Global.passwordEntered = loaded.get("passwordEntered")

	Global.moves = loaded.get("moves")

	Global.bombStr = loaded.get("bombStr")
	Global.bombQty = loaded.get("bombQty")

	Global.tpStr = loaded.get("tpStr")
	Global.tpQty = loaded.get("tpQty")

	Global.multStr = loaded.get("multStr")
	Global.multQty = loaded.get("multQty")
	
	Global.frenzyStr = loaded.get("frenzyStr")
	Global.frenzyQty = loaded.get("frenzyQty")

	Global.idleXs = loaded.get("idleXs")
	Global.idleS = loaded.get("idleS")

	Global.sold_xs = loaded.get("sold_xs")
	Global.sold_s = loaded.get("sold_s")
	Global.sold_m = loaded.get("sold_m")
	Global.sold_l = loaded.get("sold_l")
	Global.sold_xl = loaded.get("sold_xl")

	Global.dragon_gem_xs = loaded.get("dragon_gem_xs")
	Global.dragon_gem_s = loaded.get("dragon_gem_s")
	Global.dragon_gem_m = loaded.get("dragon_gem_m")
	Global.dragon_gem_l = loaded.get("dragon_gem_l")
	Global.dragon_gem_xl = loaded.get("dragon_gem_xl")

	Global.ability_card_xs = loaded.get("ability_card_xs")
	Global.ability_card_s = loaded.get("ability_card_s")
	Global.ability_card_m = loaded.get("ability_card_m")
	Global.ability_card_l = loaded.get("ability_card_l")
	Global.ability_card_xl = loaded.get("ability_card_xl")

	Global.funds = loaded.get("funds")
	
	#Loading price variables
	Prices.MoreMoves = loaded.get("MoreMoves")
	Prices.MoreMovesBought = loaded.get("MoreMovesBought")

	Prices.Mult = loaded.get("Mult")
	Prices.MultBought = loaded.get("MultBought")

	Prices.MultStr = loaded.get("MultStr")
	Prices.MultStrBought = loaded.get("MultStrBought")

	Prices.MoreBombs = loaded.get("MoreBombs")
	Prices.MoreBombsBought = loaded.get("MoreBombsBought")

	Prices.BombPower = loaded.get("BombPower")
	Prices.BombPowerBought = loaded.get("BombPowerBought")

	Prices.MoreTPs = loaded.get("MoreTPs")
	Prices.MoreTPsBought = loaded.get("MoreTPsBought")

	Prices.TPpower = loaded.get("TPpower")
	Prices.TPpowerBought = loaded.get("TPpowerBought")
	
	Prices.Frenzy = loaded.get("Frenzy")
	Prices.FrenzyBought = loaded.get("FrenzyBought")
	
	Prices.FrenzyPwr = loaded.get("FrenzyPwr")
	Prices.FrenzyPwrBought = loaded.get("FrenzyPwrBought")

	Prices.idleXs = loaded.get("idleXsPrice")
	Prices.idleXsBought = loaded.get("idleXsBought")

	Prices.idleS = loaded.get("idleSPrice")
	Prices.idleSBought = loaded.get("idleSBought")

func loadDefault():
	#Resolution settings
	Global.res = Vector2(1920,1080)
	Global.gameSize = Vector2(1920,640)
	Global.charaSize = Vector2(512,640)

	#Dev mode confirmation
	Global.passwordEntered = false

	#Options menu settings
	Global.menuOpen = false

	#Mine minigame variables
	Global.isMining = false
	Global.moves = 50

	Global.bombStr = 2
	Global.bombQty = 0

	Global.tpStr = 5
	Global.tpQty = 0

	Global.multStr = 2
	Global.multQty = 0
	Global.addActive = false

	Global.frenzyStr = 6
	Global.frenzyQty = 0

	#Idler shop variables
	Global.idleXs = 0
	Global.idleS = 0

	#Chimata camera flag
	Global.follow = false
	Global.maxUP = true
	Global.maxDOWN = true
	Global.maxLEFT = true
	Global.maxRIGHT = true
	Global.isMoving = true

	#Mine shop
	Global.mShopOpen = false
	Global.iShopOpen = false

	#Market minigame variables
	Global.wager = 0

	#Higher-lower
	Global.nb1 = 0
	Global.nb2 = 0

	#Blackjack
	Global.playerHand = 0
	Global.marisaHand = 0

	#Workshop minigame variables
	Global.hittable = false

	#Cards to be sold
	Global.sold_xs = 0
	Global.sold_s = 0
	Global.sold_m = 0
	Global.sold_l = 0
	Global.sold_xl = 0

	#Mining resources
	Global.dragon_gem_xs = 0
	Global.dragon_gem_s = 0
	Global.dragon_gem_m = 0
	Global.dragon_gem_l = 0
	Global.dragon_gem_xl = 0

	#Workshop resources
	Global.ability_card_xs = 0
	Global.ability_card_s = 0
	Global.ability_card_m = 0
	Global.ability_card_l = 0
	Global.ability_card_xl = 0

	#Funds & GUI updating
	Global.funds = 0
	
	#Mining shop
	Prices.MoreMoves = 100
	Prices.MoreMovesBought = 0

	Prices.Mult = 250
	Prices.MultBought = 0

	Prices.MultStr = 350
	Prices.MultStrBought = 0

	Prices.MoreBombs = 200
	Prices.MoreBombsBought = 0

	Prices.BombPower = 500
	Prices.BombPowerBought = 0

	Prices.MoreTPs = 600
	Prices.MoreTPsBought = 0

	Prices.TPpower = 1000
	Prices.TPpowerBought = 0

	Prices.Frenzy = 1000
	Prices.FrenzyBought = 0
	
	Prices.FrenzyPwr = 1350
	Prices.FrenzyPwrBought = 0

	#Idle shop
	Prices.idleXs = 1000
	Prices.idleXsBought = 0

	Prices.idleS = 3000
	Prices.idleSBought = 0
