tool
extends Node


var settings: SettingsResource = SettingsResource.new();
var player = null;
var level = null;
var hud = null;
var map_camera = null;

var _state = 0;
var _keys = 0;


func boss_defeated() -> void:
	_reset();
	player = null;
	level.play_completion_animation();


func play_died() -> void:
	_reset();
	player = null;
	level.play_death_animation();


func collect_key() -> void:
	_keys += 1;
	obj_find_key();


func has_keys() -> bool:
	return _keys >= 2;


func obj_heal() -> void:
	if _state <= 0:
		_state = 1;
		Global.hud.set_objective("Investigate");


func obj_kill() -> void:
	if _state <= 1:
		_state = 2;
		Global.hud.set_objective("Seek Safety");


func obj_gate() -> void:
	if _state <= 2:
		_state = 3;
		Global.hud.set_objective("Find Two Wreckages For Gate");


func obj_find_key() -> void:
	if _state <= 4:
		_state = 4;
		
		if _keys == 1:
			Global.hud.set_objective("Find One Wreckages For Gate");
		else:
			Global.hud.set_objective("Open Gate");


func obj_boss() -> void:
	if _state <= 4:
		_state = 5;
		Global.hud.set_objective("Eliminate");


func _reset() -> void:
	_keys = 0;
	_state = 0;


func _enter_tree() -> void:
	if Engine.editor_hint:
		return;
	
	var file: File = File.new();
	
	if file.file_exists("user://mi_settings.tres"):
		settings = load("user://mi_settings.tres");
	
	settings.apply();
	
	if OS.is_debug_build():
		_keys = 2;


func _exit_tree() -> void:
	if Engine.editor_hint:
		return;
	
	ResourceSaver.save("user://mi_settings.tres", settings, 0);
