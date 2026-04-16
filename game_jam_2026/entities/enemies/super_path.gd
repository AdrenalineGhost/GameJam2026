extends PathFollow2D
## The enemy's speed
@export var speed = 100
var money: int
signal death(entity:Node2D, money:int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money = self.get_child(0).health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (self.get_child(0).health <= 0):
		death.emit(self, money)
	loop_movement(delta)
	

func loop_movement(delta: float) -> void:
	progress += speed * delta
