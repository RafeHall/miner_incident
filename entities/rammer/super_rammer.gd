extends RigidBody


const GRAVITY: float = -9.8;

const MAX_SPEED: float = 8.0;
const ACCELERATION: float = 2.5;
const DECELERATION: float = 3.5;

const SCREECHES = [
	preload("res://audio/rammer_screech.wav"),
	preload("res://audio/rammer_screech_2.wav"),
];

onready var visuals = $Visuals;
onready var ground_ray = $RayCast;

export var health: int = 2;
export var detection_radius: float = 10.0;

var charging = true;
var charging_cooldown = 0.0;
var seen_player: bool = false;

var progress: float = 0.0;
var direction = Vector3(0.0, 0.0, 0.0);
var prev_speed = 0.0;

var map_color: Color = Color.orange;


func damage(amount: int) -> void:
	health -= amount;
	if health <= 0:
		Global.obj_kill();
		Global.boss_defeated();
		queue_free();


func play_screech() -> void:
	randomize();
	var i = randi() % SCREECHES.size();
	
	$AudioStreamPlayer3D.stream = SCREECHES[i];
	$AudioStreamPlayer3D.play();


func hit_player() -> void:
	if Global.player == null:
		return;
	
	if charging:
		charging = false;
		charging_cooldown = 2.0;
		Global.player.damage();


func _ready() -> void:
	$Area/CollisionShape.shape.radius = detection_radius;


func _process(delta: float) -> void:
	if Global.player == null or !seen_player:
		return;
	
	if charging_cooldown <= 0.001 and not charging:
		charging = true;
		play_screech();
	else:
		charging_cooldown -= delta;


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	if Global.player == null or !seen_player:
		return;
	
	var delta = get_physics_process_delta_time();
	
	if not charging:
		direction = (Global.player.translation - translation).normalized();
		visuals.look_at(Global.player.translation - Vector3(0.0, 1.0, 0.0), Vector3.UP);
	
	var acceleration;
	if charging:
		acceleration = ACCELERATION;
	else:
		acceleration = DECELERATION;
	
	var t = direction * MAX_SPEED * int(charging);
	var h_velocity = Vector2(state.linear_velocity.x, state.linear_velocity.z);
	h_velocity = h_velocity.linear_interpolate(Vector2(t.x, t.z), acceleration * delta);
	
	var gravity = GRAVITY * delta;
	if ground_ray.is_colliding():
		linear_velocity.y = 0.0;
		gravity = 0.0;
	
	var motion = Vector3(h_velocity.x, gravity + state.linear_velocity.y, h_velocity.y);
	var speed = motion.length();
	
	if charging:
		if speed <= prev_speed:
			charging = false;
			charging_cooldown = 2.0;
	
	prev_speed = speed;
	
	progress += speed * 0.1 + 0.025;
	$Visuals/Rammer/Cube.get_surface_material(0).set_shader_param("progress", progress);
	
	state.linear_velocity = motion;


func _player_detected(body: Node) -> void:
	if body == Global.player:
		direction = (Global.player.translation - translation).normalized();
		visuals.look_at(Global.player.translation - Vector3(0.0, 1.0, 0.0), Vector3.UP);
		
		sleeping = false;
		seen_player = true;
		play_screech();
