extends CharacterBody2D

#@export var health_drain = 10
# Health drain from player will be the same as the leftover health
@export var health = 10
@export var Spriteframes: SpriteFrames
@export var iced = false
@export var burned = false

@onready var sprite = $Sprite2D

var last_pos: Vector2
var burnDPS = 2

func _ready() -> void:
	last_pos = self.global_position
	$anim.sprite_frames = Spriteframes
	

func _process(delta: float) -> void:
	var pos_delta = self.global_position - last_pos
	if abs(pos_delta.x) > abs(pos_delta.y):
		if pos_delta.x > 0:
			$anim.play("left")
		else:
			$anim.play("right")
	else:
		if (pos_delta.y > 0):
			$anim.play("down")
		else:
			$anim.play("up")
	last_pos = self.global_position

	sprite.modulate = Color(1, 1, 1, 1)
	if(iced):
		sprite.modulate = Color(0.0, 0.885, 0.887)
	if(burned):
		sprite.modulate = Color(0.813, 0.346, 0.153)
		health -= burnDPS * delta


