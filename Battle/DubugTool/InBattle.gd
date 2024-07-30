extends HBoxContainer

var current_cardpack:String
var current_cardpack_ind:int
# Called when the node enters the scene tree for the first time.
func _ready():
	var popup:PopupMenu=$PackSelector.get_popup()
	for pack in CardLoader.get_packs():
		popup.add_item(pack)
	popup.id_pressed.connect(on_popup_selected)
	if popup.get_item_count()!=0:
		current_cardpack_ind=0
		current_cardpack=popup.get_item_text(0)
		$PackSelector.text=current_cardpack
	pass # Replace with function body.

func on_popup_selected(id:int):
	var popup:PopupMenu=$PackSelector.get_popup()
	current_cardpack_ind=id
	current_cardpack=popup.get_item_text(id)
	$PackSelector.text=current_cardpack

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
