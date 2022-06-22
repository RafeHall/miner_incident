extends Control


signal close_requested();


var settings: SettingsResource = Global.settings;

onready var master_slider = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/MasterVolume;
onready var music_slider = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer2/MusicVolume;
onready var effects_slider = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer3/EffectsVolume;
onready var fullscreen_button = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer4/FullscreenToggle;


func _ready() -> void:
	master_slider.value = settings.master_volume;
	music_slider.value = settings.music_volume;
	effects_slider.value = settings.effects_volume;
	
	fullscreen_button.pressed = settings.fullscreen;
	
	if fullscreen_button.pressed:
		fullscreen_button.text = "[X]";
	else:
		fullscreen_button.text = "[ ]";


func _master_volume_changed(value: float) -> void:
	settings.master_volume = value;


func _music_volume_changed(value: float) -> void:
	settings.music_volume = value;


func _effects_volume_changed(value: float) -> void:
	settings.effects_volume = value;


func _fullscreen_toggled(button_pressed: bool) -> void:
	settings.fullscreen = button_pressed;
	OS.window_fullscreen = button_pressed;
	
	if button_pressed:
		fullscreen_button.text = "[X]";
	else:
		fullscreen_button.text = "[ ]";


func _back_pressed() -> void:
	get_parent().remove_child(self);
	emit_signal("close_requested");
