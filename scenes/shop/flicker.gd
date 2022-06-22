extends SpotLight


var on = true;


func _physics_process(delta: float) -> void:
	randomize();
	
	if on:
		light_energy = 16.0;
		
		on = randf() < 0.995;
	else:
		light_energy = 0.0;
		
		on = randf() > 0.9;
