extends PathFollow2D
## This node contains the pathing logic for an enemy, including speeds and special powerups.
@export var speed = 100
# The enemie's speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loop_movement(delta)
	

func loop_movement(delta: float) -> void:
	progress += speed * delta
