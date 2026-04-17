extends Node2D
var current_health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlantManager.tilemap = $"world/tile_map"
	get_tree().root.print_tree()

func _on_finish_health_changed(health_drainage: int) -> void:
	current_health -= health_drainage
	GuiManager.change_health(current_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
