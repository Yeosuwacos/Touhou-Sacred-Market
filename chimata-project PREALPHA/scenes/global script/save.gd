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
		"menuOpen" : Global.menuOpen,
		
		"isMining" : Global.isMining,
		"moves" : Global.moves,
		
		"bombStr" : Global.bombStr,
		"bombQty" : Global.bombQty,
		
		"tpStr" : Global.tpStr,
		"tpQty" : Global.tpQty,
		
		"multStr" : Global.multStr,
		"multQty" : Global.multQty,
		"addActive" : Global.addActive,
		
		"idleXs" : Global.idleXs,
		"idleS" : Global.idleS,
		
		"follow" : Global.follow,
		"maxUP" : Global.maxUP,
		"maxDOWN" : Global.maxDOWN,
		"maxLEFT" : Global.maxLEFT,
		"maxRIGHT" : Global.maxRIGHT,
		"isMoving" : Global.isMoving,
		
		"mShopOpen" : Global.mShopOpen,
		"iShopOpen" : Global.iShopOpen,
		
		"wager" : Global.wager,
		
		"nb1" : Global.nb1,
		"nb2" : Global.nb2,

		"playerHand" : Global.playerHand,
		"marisaHand" : Global.marisaHand,

		"hittable" : Global.hittable,

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

		"MoreBombs" : Prices.MoreBombs,
		"MoreBombsBought" : Prices.MoreBombsBought,

		"BombPower" : Prices.BombPower,

		"MoreTPs" : Prices.MoreTPs,
		"MoreTPsBought" : Prices.MoreTPsBought,

		"TPpower" : Prices.TPpower,

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
		return
	
	var savefile = FileAccess.open(path,FileAccess.READ)
	var loaded = savefile.get_var()
	savefile.close()
	
	#Loading global variables
	Global.res = loaded.get("res")
	Global.gameSize = loaded.get("gameSize")
	Global.charaSize = loaded.get("charaSize")

	Global.passwordEntered = loaded.get("passwordEntered")

	Global.menuOpen = loaded.get("menuOpen")

	Global.isMining = loaded.get("isMining")
	Global.moves = loaded.get("moves")

	Global.bombStr = loaded.get("bombStr")
	Global.bombQty = loaded.get("bombQty")

	Global.tpStr = loaded.get("tpStr")
	Global.tpQty = loaded.get("tpQty")

	Global.multStr = loaded.get("multStr")
	Global.multQty = loaded.get("multQty")
	Global.addActive = loaded.get("addActive")

	Global.idleXs = loaded.get("idleXs")
	Global.idleS = loaded.get("idleS")

	Global.follow = loaded.get("follow")
	Global.maxUP = loaded.get("maxUP")
	Global.maxDOWN = loaded.get("maxDOWN")
	Global.maxLEFT = loaded.get("maxLEFT")
	Global.maxRIGHT = loaded.get("maxRIGHT")
	Global.isMoving = loaded.get("isMoving")

	Global.mShopOpen = loaded.get("mShopOpen")
	Global.iShopOpen = loaded.get("iShopOpen")

	Global.wager = loaded.get("wager")

	Global.nb1 = loaded.get("nb1")
	Global.nb2 = loaded.get("nb2")

	Global.playerHand = loaded.get("playerHand")
	Global.marisaHand = loaded.get("marisaHand")

	Global.hittable = loaded.get("hittable")

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

	Prices.MoreBombs = loaded.get("MoreBombs")
	Prices.MoreBombsBought = loaded.get("MoreBombsBought")

	Prices.BombPower = loaded.get("BombPower")

	Prices.MoreTPs = loaded.get("MoreTPs")
	Prices.MoreTPsBought = loaded.get("MoreTPsBought")

	Prices.TPpower = loaded.get("TPpower")

	Prices.idleXs = loaded.get("idleXsPrice")
	Prices.idleXsBought = loaded.get("idleXsBought")

	Prices.idleS = loaded.get("idleSPrice")
	Prices.idleSBought = loaded.get("idleSBought")
