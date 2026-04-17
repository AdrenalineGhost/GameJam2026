extends CanvasLayer

var currentHealth
var currentWave 

func _ready():
	GuiManager.change_health_signal.connect(on_health_changed)
	GuiManager.change_wave_signal.connect(on_wave_changed)

func _process(delta: float) -> void:
	$money.text = "%s" % Wallet.balance

func on_health_changed(new_health):
	currentHealth = new_health
	$health.value = currentHealth
	
func on_wave_changed(new_wave):
	currentWave = new_wave
	$wave_counter.text = "Wave %s" % new_wave
