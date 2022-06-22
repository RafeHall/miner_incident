extends Area


var map_color = Color.purple;


func _on_pickup(body: Node) -> void:
	hide();
	Global.collect_key();
	map_color = Color.transparent;
