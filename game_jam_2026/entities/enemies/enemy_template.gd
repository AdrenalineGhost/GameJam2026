extends CharacterBody2D

#@export var health_drain = 10
# Health drain from player will be the same as the leftover health
@export var health = 10
@export var iced = false
@export var burned = false

var burnDPS = 2

@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	sprite.modulate = Color(1, 1, 1, 1)
	if(iced):
		sprite.modulate = Color(0.0, 0.885, 0.887)
	if(burned):
		sprite.modulate = Color(0.813, 0.346, 0.153)
		health -= burnDPS * delta
