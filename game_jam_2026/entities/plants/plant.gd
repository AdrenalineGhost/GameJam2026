extends Node2D
class_name Plant

var sprite: AnimatedSprite2D
var tilemap

var placed = false
var overlapping_plants = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ready_extend()
	sprite.visible = true
	
	
func _ready_extend() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not placed:
		global_position = get_global_mouse_position()
		
		if can_place():
			sprite.modulate = Color(0, 1, 1, 0.5) # blue
		else:
			sprite.modulate = Color(1, 0, 0, 0.5) # red
	else:
		_process_extend(delta)

func _process_extend(delta: float) -> void:
	pass

func _input(event):
	if not placed and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and can_place():
			place()
			
func can_place() -> bool:
	if overlapping_plants:
		return false
	
	var mouse_pos = get_global_mouse_position()
	var cell = tilemap.local_to_map(mouse_pos)
	var tile_data = tilemap.get_cell_tile_data(cell)
	

	if tile_data:
		return tile_data.get_custom_data("buildable") != false
		
	return false  # no tile = not buildable
	
func place():
	sprite.modulate = Color(1, 1, 1) 
	placed = true
	add_to_group("plants")
	PlantManager.putDown()

func _on_placing_reserve_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("plants"):
		overlapping_plants = true


func _on_placing_reserve_area_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("plants"):
		overlapping_plants = false
