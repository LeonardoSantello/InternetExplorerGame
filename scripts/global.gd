extends Node

var playerBody: CharacterBody2D

var playerAlive : bool
var playerDamageZone: Area2D
var playerHitBox: Area2D

var playerDamageAmount: float = 10
var health: float = 100
var health_max: float = 100
var speed = 300.0
var max_speed = 300.0
var files_coleted = 0
var boss_started : bool = false

var malCabeadoDamageAmount : int
var cmosDamageAmount: int
var inimigoBasicoDamageAmount: int
var cavaloDeTroiaDamageAmount: int
var invaderDamageAmount: int
var ddosDamageAmount: int
var bossDamageAmount: int
var spikeDamageAmount: int
var xDamageAmount: int = 35
var folderDamageAmount: int = 20
var laserDamageAmount: int = 35

func reset_game_state():
	playerDamageAmount = 10
	health = 100
	health_max = 100
	speed = 300.0
	max_speed = 300.0
	files_coleted = 0
	boss_started = false
