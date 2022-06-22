extends Area


var map_color = Color.cyan;


func _on_heal_player(_body: Node) -> void:
	Global.obj_heal();
	Global.player.shield = Global.player.max_shield;
	map_color = Color.transparent;
	
	$AnimationPlayer.play("dissapear");
	$ShieldCharge.play();
