extends Node

var playerBody: CharacterBody2D

var playerAlive : bool
var playerDamageZone: Area2D
var playerDamageAmount: float = 10

var health: float = 100
var health_max: float = 100
var health_min: float = 0

var cmosDamageZone = Area2D
var cmosDamageAmount: int
