extends Control


onready var health_progress = $VBoxContainer/PanelContainer/HBoxContainer/PanelContainer/Health;
onready var shield_progress = $VBoxContainer/PanelContainer/HBoxContainer/PanelContainer/Shield;
onready var laser_progress = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/Laser/TextureProgress;
onready var rocket_count = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/Rockets/MarginContainer/Label;
onready var objective_text = $Label;
onready var minimap = $PanelContainer/Minimap;


func _enter_tree() -> void:
	Global.hud = self;


func _ready() -> void:
	minimap.camera = Global.map_camera;


func set_objective(objective: String) -> void:
	objective_text.text = "Current Directive: " + objective;


func _process(delta: float) -> void:
	if Global.player != null:
		laser_progress.value = int(Global.player.laser_ready);
		rocket_count.text = str(Global.player.rockets);
		
		health_progress.max_value = Global.player.max_health;
		health_progress.value = Global.player.health;
		
		shield_progress.max_value = Global.player.max_shield;
		shield_progress.value = Global.player.shield;
	
