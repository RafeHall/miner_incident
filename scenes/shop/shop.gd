extends Spatial


var paused = false;
var settings_scene;

onready var projectiles = $Projectiles;

onready var camera = $Camera/Pivot/Camera;


func play_death_animation() -> void:
	$PlayerDeath/AnimationPlayer.play("death", -1, 1.0, false);


func play_completion_animation() -> void:
	$Completion/AnimationPlayer.play("completion", -1, 1.0, false);


func open_gate() -> void:
	$Decorations/Gate/AnimationPlayer.play("Cube001Action", -1, 0.25);
	
	Global.obj_boss();


func _enter_tree() -> void:
	Global.level = self;
	Global.map_camera = $MapCamera;


func _ready() -> void:
	Global.hud.set_objective("Recharge Shield");
	
	settings_scene = load("res://ui/settings/settings.tscn").instance();
	settings_scene.connect("close_requested", self, "_settings_close_requested");
	
	$FadeIn/AnimationPlayer.play("fade");


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			$UI/ViewportContainer/Viewport.remove_child(settings_scene);
		else:
			$UI/ViewportContainer/Viewport.add_child_below_node($UI/ViewportContainer/Viewport/Hud, settings_scene);
		
		paused = !paused;


func _settings_close_requested() -> void:
	paused = false;


func _death_animation_finished(_anim_name: String) -> void:
	get_tree().change_scene("res://ui/main_menu/main_menu.tscn");


func _completion_animation_finished(_anim_name: String) -> void:
	get_tree().change_scene("res://ui/credits/credits.scn");
