extends Node

var placing = false
var tilemap

func pickUp(plant):
	print(get_tree().root.get_children())
	print("picked up ")
	placing = true
	var inst = plant.instantiate()
	inst.tilemap = tilemap
	add_child(inst)
	print(inst)
	
func putDown():
	placing = false
	pass
