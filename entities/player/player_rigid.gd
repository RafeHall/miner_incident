tool
extends RigidBody


const GRAVITY: float = -9.8;

const TURN_SPEED: float = 160.0;
const TURN_ACCELERATION: float = 4.0;
const TURN_DECELERATION: float = 8.0;

const MAX_SPEED: float = 6.0;
const DEBUG_MAX_SPEED: float = 10.0;
const ACCELERATION: float = 2.0;
const DECELERATION: float = 0.75;

const LASER_COOLDOWN: float = 0.9;

const HULL_SOUNDS: Array = [
	preload("res://audio/hull_impact.wav"),
	preload("res://audio/hull_impact_2.wav"),
];

var turn_velocity: float = 0.0;

export var forward: float = 0.0 setget _set_forward;

export var health: int = 3;
export var max_health: int = 3;

export var shield: int = 6;
export var max_shield: int = 6;

export var rockets: int = 5;
var laser_ready: bool = true;

var laser_scene = preload("res://entities/laser/laser.scn");
var rocket_scene = preload("res://entities/rocket/rocket.scn");

onready var hitbox: Area = $Hitbox;
onready var visuals: Spatial = $Visuals;
onready var ground_ray: RayCast = $RayCast;

var map_color: Color = Color.green;


func damage(amount: int = 1) -> void:
	if shield <= 0:
		health -= amount;
		
		randomize();
		var i = randi() % HULL_SOUNDS.size();
		
		$HullDamage.pitch_scale = 1.0 + rand_range(-0.1, 0.1);
		$HullDamage.stream = HULL_SOUNDS[i];
		$HullDamage.play();
		
		if health <= 0:
			visuals.hide();
			$Particles/Explode.emitting = true;
			Global.play_died();
	else:
		var new_shield = clamp(shield - amount, 0, max_shield);
		health -= amount - (shield - new_shield);
		shield = new_shield;
		
		randomize();
		$ShieldDamage.pitch_scale = 1.0 + rand_range(-0.1, 0.1);
		$ShieldDamage.play();


func create_laser() -> void:
	$LaserAudio.pitch_scale = 1.0 + rand_range(-0.1, 0.1);
	$LaserAudio.play();
	
	var laser = laser_scene.instance();
	laser.translation = self.translation - Vector3(0.0, 0.25, 0.0);
	laser.rotation_degrees.y = -forward - 90.0;
	
	Global.level.projectiles.add_child(laser);


func create_rocket() -> void:
	$RocketAudio.pitch_scale = 1.0 + rand_range(-0.1, 0.1);
	$RocketAudio.play();
	
	var rocket = rocket_scene.instance();
	rocket.translation = self.translation - Vector3(0.0, 0.25, 0.0);
	rocket.rotation_degrees.y = -forward - 90.0;
	
	Global.level.projectiles.add_child(rocket);


func _enter_tree() -> void:
	Global.player = self;


func _process(delta: float) -> void:
	if Engine.editor_hint:
		return;
	
	if Input.is_action_just_pressed("laser") and laser_ready:
		laser_ready = false;
		
		get_tree().create_timer(LASER_COOLDOWN).connect("timeout", self, "set", ["laser_ready", true], CONNECT_ONESHOT);
		create_laser();
	
	if Input.is_action_just_pressed("rocket") and rockets > 0:
		rockets -= 1;
		create_rocket();
	
	var speed;
	if OS.is_debug_build():
		speed = DEBUG_MAX_SPEED;
	else:
		speed = MAX_SPEED;
	
	var speed_scale = linear_velocity.length() / speed;
	$EngineAudio.pitch_scale = speed_scale * 0.2 + 0.9;


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	var delta = get_physics_process_delta_time();
	
	var input_direction = _get_input_direction();
	
	var turn_target = input_direction.x * TURN_SPEED;
	
	var turn_acceleration;
	if abs(input_direction.x) > 0.01:
		turn_acceleration = TURN_ACCELERATION;
	else:
		turn_acceleration = TURN_DECELERATION;
	
	turn_velocity = lerp(turn_velocity, turn_target, turn_acceleration * delta);
	
	forward += turn_velocity * delta;
	
	visuals.rotation_degrees.y = -forward;
	
	var direction = Vector2(0, 1).rotated(deg2rad(forward)) * input_direction.y;
	
	var target;
	if OS.is_debug_build():
		target = direction * DEBUG_MAX_SPEED;
	else:
		target = direction * MAX_SPEED;
	
	var acceleration;
	if input_direction.y > 0:
		acceleration = ACCELERATION;
	else:
		acceleration = DECELERATION;
	
	var h_velocity = Vector2(state.linear_velocity.x, state.linear_velocity.z);
	h_velocity = h_velocity.linear_interpolate(target, acceleration * delta);
	
	var gravity = GRAVITY * delta;
	if ground_ray.is_colliding():
		linear_velocity.y = 0.0;
		gravity = 0.0;
	
	var motion = Vector3(h_velocity.x, gravity + state.linear_velocity.y, h_velocity.y);
	
	state.linear_velocity = motion;


#	var result = move_and_collide(motion * delta, true, true, true);
#	if result != null && result.normal.dot(Vector3.UP) < deg2rad(45.0):
#		result = move_and_collide(motion * delta, true, true, false);
#
#		# Might be redundant...
#		if result != null:
#			motion = motion.bounce(result.normal);
#			move_and_slide(motion * result.remainder, Vector3.UP, false, 4, deg2rad(45.0));
#	else:
#		velocity = move_and_slide(motion, Vector3.UP, false, 4, deg2rad(45.0));


func _get_input_direction() -> Vector2:
	var x = int(Input.is_action_pressed("turn_right")) - int(Input.is_action_pressed("turn_left"));
	var y = int(Input.is_action_pressed("move_forward"));
	
#	var y = int(Input.is_action_pressed("move_forward")) - int(Input.is_action_pressed("move_back"));
	
	return Vector2(x, y);


func _set_forward(f: float) -> void:
	forward = f;
	
	$Visuals.rotation_degrees.y = -forward;
	


func _hitbox_body(body: Node) -> void:
	if body.has_method("hit_player"):
		body.hit_player();
