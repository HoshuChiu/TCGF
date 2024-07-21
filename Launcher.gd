extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_size(Vector2i(1200,750))
	DisplayServer.window_set_title("TCGF")
	get_tree().change_scene_to_file("res://Battle/Battlefield.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
