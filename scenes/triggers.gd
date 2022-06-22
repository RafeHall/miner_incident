extends Node


onready var metal_ambience = $MetalAmbience;


func _ready() -> void:
	metal_ambience.connect("body_entered", self, "_metal_ambience");


func _metal_ambience(_body: Node) -> void:
	get_node("../Audio/MetalAmbience").play(8.0);
