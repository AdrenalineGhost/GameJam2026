extends Node2D
## This script contains all logic for enemy spawning

@export_category("Timing")
## Whether or not to scale time between spawns
@export var time_between_spawns_scaling = false 
## Amount of time between each individual spawn in ms
@export var time_between_spawns = 150
## Timeout per wave in s
@export var timeout = 30
## Money you start with
@export var money = 0

@export_category("Difficulty")
## Difficulty will scale linearly with wave_number
## This value will decide what enemies spawn at what times
@export_enum("Easy:1", "Normal:2", "Hard:3", "Insane:4") var difficulty = 2
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
@export var pathing_node_name = "pathing"
@export var finish_node_name = "finish"

# Signals
signal wave_change(wave:int)

# Sister nodes needed
var pathing_node: Path2D
var finish_node: Area2D

# Variables
var wave = 0
var player_node: CharacterBody2D
var time = 0
var total_time = 0
var wave_time = 0
var amount_spawned = 0
var total_amount_spawned = 0
var pause = false
var amount_enemies_last_round = 0

func _process(delta: float) -> void:
	_increment_time(delta)
	if(!_wave_started()):
		return
	if(_spawn_check()):
		# Should probs be multithreaded
		_spawn_enemy(_decide_enemy())

func _increment_time(delta: float):
	time += delta
	wave_time += delta
	total_time += delta
	
func _wave_started() -> bool:
	if(!pause):
		return true
	if (time >= timeout):
		_start_wave()
		return true
	return false
	
func _spawn_check() -> bool:
	if (time>=time_between_spawns*.01):
		time = 0
		
		if (amount_spawned < amount_enemies_last_round + amount_of_enemies + (amount_of_enemies_scaling ** wave)):
			return true
		amount_enemies_last_round += amount_of_enemies + (amount_of_enemies_scaling ** wave)
		_end_wave()
	return false
	
func _end_wave():
	total_amount_spawned += amount_spawned
	amount_spawned = 0
	time = 0
	pause = true
	
func _spawn_enemy(enemy: PackedScene) -> PathFollow2D:
	## Will spawn the enemy entity and return its node
	var temp = enemy.instantiate()
	temp.death.connect(_death_cleanup)
	_calculate_stats(temp.get_child(0))
	pathing_node.add_child(temp)
	amount_spawned += 1
	return temp
	
func _calculate_stats(enemy: CharacterBody2D):
	enemy.health = enemy.health + (health_scaling ** wave)
	
func _decide_enemy() -> PackedScene:
	## Should decide what enemy to spawn
	return easy_enemies[0]
	
func _start_wave():
	wave += 1
	GuiManager.change_wave(wave)
	pause = false
	time = 0
	
func _ready() -> void:
	finish_node = _type_check("Area2D", finish_node_name)
	pathing_node = _type_check("Path2D", pathing_node_name)
	_start_wave()

func _type_check(type:String, name:String) -> Node:
	var temp = get_parent().get_node(name)
	return temp
	
func _death_cleanup(entity:Node2D, money:int):
	self.money += money
	entity.queue_free()

	






	

	

	
	

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
