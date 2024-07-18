extends Sprite3D
class_name BasicCard

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = preload("res://icon.svg") as Texture
	self.texture=texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
