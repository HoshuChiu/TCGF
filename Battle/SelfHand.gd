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

func repos_hand_cards(count:int,position:int):
	BattleInfoMgr.self_card_hand_count+=count
	for child in get_children():
		if child.slot>position:
			child.on_adjust(child.slot+count)
		else:
			child.on_adjust(child.slot)
	pass

func on_draw(args):
	BattleInfoMgr.self_card_hand_count+=1
	
func draw_done(args):
	add_child(args)

func readjust():
	for child in get_children():
		child.on_adjust(child.slot)
	pass

func on_card_hovered(slot:int):
	if hovered_slot==slot:
		for child in get_children():
			if child.slot==slot:
				child.on_hover()
		return
	elif _anim_enable==true:
		for child in get_children():
			if child.slot==slot:
				child.on_show()
			elif child.slot==hovered_slot:
				child.on_adjust(child.slot)
				pass
		hovered_slot=slot
		_anim_enable=false
		_anim_timer=0
	else:
		if _anim_timer>0.1:
			_anim_enable=true

func on_hover_cancel():
	if hovered_slot==-1:
		return
	if _anim_enable:
		for child in get_children():
			if child.slot==hovered_slot:
				child.on_adjust(child.slot)
		hovered_slot=-1
		_anim_timer=0
		_anim_enable=false
	else:
		if _anim_timer>0.1:
			_anim_enable=true
