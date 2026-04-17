extends Control

var shooter = preload("res://entities/plants/turret_plant.tscn")
var fire = preload("res://entities/plants/fire_plant.tscn")
var ice = preload("res://entities/plants/ice_plant.tscn")

var shooterPrice = 1
var firePrice = 2
var icePrice = 2

@onready var ShooterButton = $ShooterButton
@onready var FireButton = $FireButton
@onready var IceButton = $IceButton

func _ready() -> void:
	ShooterButton.text = "Buy Shooter Plant (%s)" % shooterPrice
	FireButton.text = "Buy FireShooter Plant (%s)" % firePrice
	IceButton.text = "Buy IceShooter Plant (%s)" % icePrice

func _on_shooter_button_pressed() -> void:
	if(PlantManager.placing):
		return
	if(Wallet.checkWalletHasEnoughFor(1)):
		Wallet.takeMoney(1)
		PlantManager.pickUp(shooter)



func _on_fire_button_pressed() -> void:
	if(PlantManager.placing):
		return
	if(Wallet.checkWalletHasEnoughFor(2)):
		Wallet.takeMoney(2)
		PlantManager.pickUp(fire)


func _on_ice_button_pressed() -> void:
	if(PlantManager.placing):
		return
	if(Wallet.checkWalletHasEnoughFor(2)):
		Wallet.takeMoney(2)
		PlantManager.pickUp(ice)
