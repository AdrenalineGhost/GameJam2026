extends Node

signal change_wave_signal
signal change_health_signal

func change_wave(wave):
	change_wave_signal.emit(wave)
	
func change_health(health):
	change_health_signal.emit(health)
