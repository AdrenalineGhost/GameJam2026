extends CanvasLayer




func _on_health_change(health_drainage: int) -> void:
	$health.value -= health_drainage

func _on_spawner_block_wave_change(wave: int) -> void:
	$wave_counter.text = "Wave %s" % wave
