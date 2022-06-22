extends PanelContainer


var camera: Camera = null;


func _physics_process(delta: float) -> void:
	update();


func _draw() -> void:
	if camera != null && Global.player != null:
		var delta = get_physics_process_delta_time();
		var objects = get_tree().get_nodes_in_group("minimap_visible");
		
		for object in objects:
			if object is Spatial:
				var color = object.get("map_color");
				if color == null:
					color = Color.purple;
				
				var id = object.get_instance_id();
				seed(id);
				var alpha = rand_range(0.0, 1.0);
				seed(id * 2.0);
				var offset = rand_range(-1.0, 1.0);
				var distance = object.translation.distance_to(Global.player.translation);
				
				color.a *= clamp(sin((alpha + offset + OS.get_ticks_msec() / 1000.0) * 2.5), 0.0, 1.0);
				
				if distance > 0.05:
					color.a *= 1.0 - (distance / 30.0);
				
				var viewport_pos = camera.unproject_position(object.global_transform.origin);
				var start_size = camera.get_viewport().size;
				var size = rect_size;
				var pos = Vector2((size.x / start_size.x) * viewport_pos.x, (size.y / start_size.y) * viewport_pos.y);
				
				draw_circle(pos, 3.0, color);
