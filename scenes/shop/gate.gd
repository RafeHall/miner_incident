extends Area


func _triggered(body: Node) -> void:
	Global.obj_gate();
	
	if Global.has_keys():
		Global.level.open_gate();
