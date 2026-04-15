extends Node2D
## This script contains all logic for enemy spawning

@export_category("Timing")
## Whether or not to scale time between spawns
@export var time_between_spawns_scaling = false 
## Amount of time between each individual spawn in ms
@export var time_between_spawns = 150
## Timeout per wave in s
@export var timeout = 10

@export_category("Difficulty")
## Difficulty will scale linearly with wave_number
## This value will decide what enemies spawn at what times
@export_enum("Easy:1", "Normal:2", "Hard:3", "Insane:4") var difficulty = 2
## Wave number, everything scales with this value
@export var starting_wave_number = 1
## Modifier value for each progressive enemy's health scaling
@export var health_scaling = 1.02
## Modifier for health drainage on player
@export var health_drainage = 1
## Starting amount of enemies in wave 1, is multiplied with scaling
@export var amount_of_enemies = 1
## Modifier value for amount of enemies per wave
@export var amount_of_enemies_scaling = 1.1

@export_category("Enemy Types")
## Most common enemy
@export var easy_enemies: Array[PackedScene]
@export var normal_enemies: Array[PackedScene]
@export var hard_enemies: Array[PackedScene]
## These will be akin to bosses
@export var insane_enemies: Array[PackedScene]
## These will be enemies with special modifiers or powerups
@export var special_enemies: Array[PackedScene]

@export_category("Development")
@export var hide_sprite = true

var time = 0


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	time += delta
	if (time>=time_between_spawns*.01):
		time = 0
		var temp = easy_enemies[0].instantiate()
		self.get_parent().get_node("pathing").add_child(temp)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
