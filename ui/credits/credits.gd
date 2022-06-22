extends Control


onready var credits = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Text/MarginContainer/Credits;


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().change_scene("res://ui/main_menu/main_menu.tscn");
