extends Node
class_name SelfHand

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func repos_hand_cards(count:int,position:int):
	var i:int=0
	BattleInfoMgr.self_card_hand_count+=count
	for child in get_children():
		if i==position:
			i+=count
		child.render_priority=i
		if i==BattleInfoMgr.self_card_hand_count:
			break
		#child.position=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,i)
		child.on_adjust(i)
		child.rotation=BattleInfoMgr.calc_card_rotation(i).get_euler()
		i+=1
	pass
