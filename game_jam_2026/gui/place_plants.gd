extends Control

var shooter = preload("res://entities/plants/turret_plant.tscn")

func _on_shooter_button_pressed() -> void:
	if(PlantManager.placing):
		return
	PlantManager.pickUp(shooter)
