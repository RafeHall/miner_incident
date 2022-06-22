tool
extends RichTextEffect
class_name RichTextGhost


var logged_characters: Dictionary = {};
var bbcode = "ghost";


func _process_custom_fx(char_fx):
	var speed = char_fx.env.get("speed", 5.0);

	var alpha = (char_fx.elapsed_time * speed - char_fx.absolute_index) > 1.0;
	char_fx.color.a = int(alpha);
	
	if alpha and not logged_characters.has(char_fx.absolute_index):
		logged_characters[char_fx.absolute_index] = true;
		
		
	
	return true;
