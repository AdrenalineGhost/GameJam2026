extends PathFollow2D
## The enemy's speed
@export var speed = 100
var money: int

@onready var sprite = $easy_enemy/anim

signal death(entity:Node2D, money:int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money = 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (self.get_child(0).health <= 0):
		death.emit(self, money)
	loop_movement(delta)
	

func loop_movement(delta: float) -> void:
	var speed_modifier = 0.5 if self.get_child(0).iced else 1.0
	progress += speed * delta * speed_modifier
