extends Node

var playerBody: CharacterBody2D

var playerAlive : bool
var playerDamageZone: Area2D
var playerDamageAmount: int = 10

var health = 100
var health_max = 100
var health_min = 0

var cmosDamageZone = Area2D
var cmosDamageAmount: int
