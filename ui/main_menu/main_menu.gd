extends Control


var start = false;

var background_loader = load("res://ui/main_menu/background_loader.gd").new();

onready var screen_text: RichTextLabel = $CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Text/RichTextLabel;


func _is_html5() -> bool:
	return OS.get_name() == "HTML5";


func _ready() -> void:
	if not _is_html5():
		background_loader.load_res("res://scenes/shop/shop.scn");


func _process(delta: float) -> void:
	if _is_html5():
		return;
	
	if background_loader.done() && start:
		var scene = background_loader.get_res()
		background_loader.dispose();
		
		get_tree().change_scene_to(scene);


func _start_pressed() -> void:
	$CenterContainer.hide();
	
	start = true;
	
	if _is_html5():
		get_tree().create_timer(0.2).connect("timeout", get_tree(), "change_scene", ["res://scenes/shop/shop.scn"], CONNECT_ONESHOT);


func _settings_pressed() -> void:
	var settings_scene = preload("res://ui/settings/settings.tscn").instance();
	settings_scene.connect("close_requested", $CenterContainer, "show", [], CONNECT_ONESHOT);
	
	add_child_below_node($CenterContainer, settings_scene);
	
	$CenterContainer.hide();


func _exit_pressed() -> void:
	get_tree().quit();
