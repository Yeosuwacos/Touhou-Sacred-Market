extends Node2D

#Mine minigame flags
var isMining = false
var moves = 20

#Chimata camera flag
var follow = false

#Workshop minigame flags
var game1Running = false

#Market minigame variables
var nb1 = 0
var nb2 = 0

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
var ability_card_xs = 9
var ability_card_s = 9
var ability_card_m = 9
var ability_card_l = 9
var ability_card_xl = 9

#Funds & GUI updating
var funds = 0
