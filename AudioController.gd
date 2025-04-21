extends Node

@export var texture: Control

@onready var audio_player = $AudioStreamPlayer
@onready var spectrum = AudioServer.get_bus_effect_instance(1, 0) as AudioEffectSpectrumAnalyzerInstance

var shader_mat: ShaderMaterial

func _ready():
	audio_player.play()
	
	shader_mat = texture.material as ShaderMaterial

func _process(_delta):
	if spectrum:
		var bass = spectrum.get_magnitude_for_frequency_range(20, 80).length()  # Bass range: 20-80 Hz
		var mid_bass = spectrum.get_magnitude_for_frequency_range(80, 250).length()  # Mid-bass range: 80-250 Hz
		var mid = spectrum.get_magnitude_for_frequency_range(250, 1000).length()  # Mid range: 250-1000 Hz
		var upper_mid = spectrum.get_magnitude_for_frequency_range(1000, 4000).length()  # Upper mid range: 1000-4000 Hz
		var treble = spectrum.get_magnitude_for_frequency_range(4000, 8000).length()  # Treble range: 4000-8000 Hz
		var high_treble = spectrum.get_magnitude_for_frequency_range(8000, 16000).length()  # High treble range: 8000-16000 Hz

		bass = clamp(bass * 2.5, 0.0, 1.0)
		mid_bass = clamp(mid_bass * 2.5, 0.0, 1.0)
		mid = clamp(mid * 2.5, 0.0, 1.0)
		upper_mid = clamp(upper_mid * 2.5, 0.0, 1.0)
		treble = clamp(treble * 2.5, 0.0, 1.0)
		high_treble = clamp(high_treble * 2.5, 0.0, 1.0)

		shader_mat.set_shader_parameter("bass_amp", bass)
		shader_mat.set_shader_parameter("mid_bass_amp", mid_bass)
		shader_mat.set_shader_parameter("mid_amp", mid)
		shader_mat.set_shader_parameter("upper_mid_amp", upper_mid)
		shader_mat.set_shader_parameter("treble_amp", treble)
		shader_mat.set_shader_parameter("high_treble_amp", high_treble)
