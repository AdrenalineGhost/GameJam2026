extends Node

var placing = false
@onready var tilemap = self.get_parent().get_node("tile_map")

func pickUp(plant):
	print(get_tree().root.get_children())
	print("picked up ")
	placing = true
	var inst = plant.instantiate()
	inst.tilemap = tilemap
	add_child(inst)
	
func putDown():
	placing = false
	pass
