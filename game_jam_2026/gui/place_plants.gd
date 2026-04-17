extends Control

var shooter = preload("res://entities/plants/turret_plant.tscn")
var fire = preload("res://entities/plants/fire_plant.tscn")
var ice = preload("res://entities/plants/ice_plant.tscn")

func _on_shooter_button_pressed() -> void:
	if(PlantManager.placing):
		return
	PlantManager.pickUp(shooter)



func _on_fire_button_pressed() -> void:
	if(PlantManager.placing):
		return
	PlantManager.pickUp(fire)


func _on_ice_button_pressed() -> void:
	if(PlantManager.placing):
		return
	PlantManager.pickUp(ice)
