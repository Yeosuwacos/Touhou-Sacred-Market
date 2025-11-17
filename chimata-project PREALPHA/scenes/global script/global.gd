extends Node2D

#Resolution settings
var res = Vector2i(1920,1080)
var amp = 3

#Options menu settings
var menuOpen = false

#Mine minigame variables
var isMining = false
var moves = 20

var bombStr = 2
var bombQty = 1

var tpStr = 5
var tpQty = 1

#Chimata camera flag
var follow = false
var maxUP = true
var maxDOWN = true
var maxLEFT = true
var maxRIGHT = true
var isMoving = true

#Mine shop
var mShopOpen = false

#Market minigame variables
var nb1 = 0
var nb2 = 0
var wager = 0

#Workshop minigame variables
var hittable = false

#Cards to be sold
var sold_xs = 0
var sold_s = 0
var sold_m = 0
var sold_l = 0
var sold_xl = 0

#Mining resources
var dragon_gem_xs = 1000
var dragon_gem_s = 1000
var dragon_gem_m = 1000
var dragon_gem_l = 1000
var dragon_gem_xl = 1000

#Workshop resources
var ability_card_xs = 9
var ability_card_s = 9
var ability_card_m = 9
var ability_card_l = 9
var ability_card_xl = 9

#Funds & GUI updating
var funds = 0
