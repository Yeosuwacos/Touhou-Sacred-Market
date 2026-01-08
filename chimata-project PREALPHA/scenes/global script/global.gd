extends Node2D

#Resolution settings
var res = Vector2i(1280,720)

#Dev mode confirmation
var passwordEntered = false

#Options menu settings
var menuOpen = false

#Mine minigame variables
var isMining = false
var moves = 20

var bombStr = 2
var bombQty = 1

var tpStr = 5
var tpQty = 1

var addStr = 2
var addQty = 1
var addActive = false

#Idler shop variables
var idleXs = 0

#Chimata camera flag
var follow = false
var maxUP = true
var maxDOWN = true
var maxLEFT = true
var maxRIGHT = true
var isMoving = true

#Mine shop
var mShopOpen = false
var iShopOpen = false

#Market minigame variables
var wager = 0

#Higher-lower
var nb1 = 0
var nb2 = 0

#Blackjack
var playerHand = 0
var marisaHand = 0

#Workshop minigame variables
var hittable = false

#Cards to be sold
var sold_xs = 0
var sold_s = 0
var sold_m = 0
var sold_l = 0
var sold_xl = 0

#Mining resources
var dragon_gem_xs = 0
var dragon_gem_s = 0
var dragon_gem_m = 0
var dragon_gem_l = 0
var dragon_gem_xl = 0

#Workshop resources
var ability_card_xs = 0
var ability_card_s = 0
var ability_card_m = 0
var ability_card_l = 0
var ability_card_xl = 0

#Funds & GUI updating
var funds = 0
