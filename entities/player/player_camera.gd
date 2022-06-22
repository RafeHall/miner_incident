extends Spatial


const FLOAT_SPEED: float = 7.5;
const LOOK_SPEED: float = 75.0;

export(float, 2.0, 10.0) var view_radius = 4.0;
export(float, 0.0, 89.9) var view_angle = 85.0;
export(NodePath) var player_node_path = null;

var player_node: Spatial = null;
var view_yaw: float = 45.0;

onready var pivot = $Pivot;
onready var camera = $Pivot/Camera;


func _ready() -> void:
	camera.translation.z = view_radius;
	
	if player_node_path != null:
		player_node = get_node(player_node_path);


func _physics_process(delta: float) -> void:
	var input_direction = _get_input_direction();
	
	if player_node != null:
		var player_translation = player_node.translation;
		var player_rotation = player_node.visuals.rotation_degrees;
		translation = translation.linear_interpolate(player_translation, FLOAT_SPEED * delta);
		
		pivot.rotation_degrees = Vector3(-view_angle, view_yaw, 0.0);
		
		camera.look_at(player_translation, Vector3.UP);
		
		view_yaw = lerp(view_yaw, player_rotation.y - 180.0, LOOK_SPEED * delta);


func _get_input_direction() -> float:
	return float(Input.is_action_pressed("look_left")) - float(Input.is_action_pressed("look_right"));
