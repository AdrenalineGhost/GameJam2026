extends PathFollow2D

const speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loop_movement(delta)
	

func loop_movement(delta: float) -> void:
	progress += speed * delta
