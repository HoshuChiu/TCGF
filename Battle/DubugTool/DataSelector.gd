extends MenuButton
class_name DataSelector
enum datatype{
	TYPE,
	RARITY,
	JOB
}
var current_id:int=0
# Called when the node enters the scene tree for the first time.
func _init(type:datatype,val:int=0):
	var popup:PopupMenu=get_popup()
	match type:
		datatype.TYPE:
			popup.add_item("随从")
			popup.add_item("法术")
			popup.add_item("武器")
			popup.add_item("建筑")
			popup.add_item("其他")
			name="type"
		datatype.RARITY:
			popup.add_item("无")
			popup.add_item("普通")
			popup.add_item("稀有")
			popup.add_item("史诗")
			popup.add_item("传说")
			name="rarity"
		datatype.JOB:
			popup.add_item("中立")
			popup.add_item("骑士")
			popup.add_item("法师")
			popup.add_item("牧师")
			popup.add_item("恶魔")
			popup.add_item("影剑士")
			name="class"
	current_id=val
func _ready():
	var popup:PopupMenu=get_popup()
	custom_minimum_size.x=60
	popup.id_pressed.connect(on_id_pressed)
	text=popup.get_item_text(current_id)
	pass # Replace with function body.

func on_id_pressed(id:int):
	var popup:PopupMenu=get_popup()
	text=popup.get_item_text(id)
	current_id=id
	pass
	
func get_data()->int:
	return current_id
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
