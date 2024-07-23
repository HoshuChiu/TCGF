extends Node
class_name SelfHand

@onready var hovered_slot:int=-1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var _anim_enable:bool
var _anim_timer:float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_anim_timer+=delta
	pass

func on_draw(args):
	BattleInfoMgr.self_card_hand_count+=1
	
func draw_done(args):
	add_child(args)

func readjust():
	for child in get_children():
		child._adjust(child.slot)
	pass
