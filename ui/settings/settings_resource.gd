extends Resource
class_name SettingsResource


export var master_volume: float = 50.0 setget _set_master;
export var music_volume: float = 50.0 setget _set_music;
export var effects_volume: float = 50.0 setget _set_effects;
export var fullscreen: bool = true setget _set_fullscreen;


func apply() -> void:
	_set_bus_volume("Master", master_volume);
	_set_bus_volume("Music", music_volume);
	_set_bus_volume("Effects", effects_volume);
	
	OS.window_fullscreen = fullscreen;


func _set_bus_volume(bus_name: String, volume: float) -> void:
	var bus = AudioServer.get_bus_index(bus_name);
	AudioServer.set_bus_volume_db(bus, linear2db(volume / 100.0));


func _set_master(volume: float) -> void:
	_set_bus_volume("Master", volume);
	
	master_volume = volume;


func _set_music(volume: float) -> void:
	_set_bus_volume("Music", volume);
	
	music_volume = volume;


func _set_effects(volume: float) -> void:
	_set_bus_volume("Effects", volume);
	
	effects_volume = volume;


func _set_fullscreen(value: bool) -> void:
	OS.window_fullscreen = fullscreen;
	
	fullscreen = value;
