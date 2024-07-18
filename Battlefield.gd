extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_size(Vector2i(1200,675))
	DisplayServer.window_set_title("TCGF")
	for i in range(0,5):
		var card=BasicCard.new()
		card.position=Vector3(-i,-i,-i)
		add_child(card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
