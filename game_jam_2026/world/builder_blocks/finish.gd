extends Area2D
var health_drainage = 1
signal health_changed(health_drainage: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("enemy"):
		health_changed.emit(health_drainage)
