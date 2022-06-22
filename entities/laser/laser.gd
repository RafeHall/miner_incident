extends Spatial


const SPEED: float = 20.0;
const FORWARD: Vector3 = Vector3(1.0, 0.0, 0.0);


func _physics_process(delta: float) -> void:
	translate_object_local(FORWARD * SPEED * delta);


func _on_hit(body: Node) -> void:
	$Visuals/MeshInstance.hide();
	$AnimationPlayer.play("light");
	
	set_physics_process(false);
	get_tree().create_timer(0.5).connect("timeout", self, "queue_free", [], CONNECT_ONESHOT);
	
	if body.has_method("damage"):
		body.damage(1);
