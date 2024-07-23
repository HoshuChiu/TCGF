extends Node
class_name Superdomain

@onready var anims:Anims=Anims.new()

func draw():
	#确定施放对象
	var card=$"../SelfHeap".get_child(0)
	var dst_slot:int=BattleInfoMgr.self_card_hand_count
	var pack_id:String="1"
	var card_id:int=randi()%10
	exec_command("draw",card,dst_slot,[pack_id,card_id],null,null,null,card,card)

func play():
	print("play")

func exec_command(
	command:String,
	card:Node,
	dst_slot:int,
	card_on_arg:Variant,
	src_on_arg:Variant,
	dst_on_arg:Variant,
	card_done_arg:Variant,
	src_done_arg:Variant,
	dst_done_arg:Variant):
	var command_objs=get_command_objs(command)
	var src:Node=command_objs["src"]
	var dst:Node=command_objs["dst"]
	var src_area:BattleInfoMgr.BattleArea=command_objs["src_area"]
	var dst_area:BattleInfoMgr.BattleArea=command_objs["dst_area"]
	#变更施法对象信息
	if card.has_method("on_"+command):
		card.call("on_"+command,card_on_arg)
	#变更始发地信息
	if src.has_method("on_"+command):
		src.call("on_"+command,src_on_arg)
	#变更终点信息
	if dst.has_method("on_"+command):
		dst.call("on_"+command,dst_on_arg)
	
	#应用施法对象的动画
	var dst_pos=BattleInfoMgr.calc_card_position(dst_area,dst_slot)
	var dst_rot=BattleInfoMgr.calc_card_rotation(dst_area,dst_slot)
	if card.has_method(command):
		card.call(command,card.apply_anim(command,card_done_arg),dst_pos,dst_rot)
	else:
		anims.call(command,card,card.apply_anim(command,card_done_arg),dst_pos,dst_rot)
		
	#应用Readjust动画
	dst.readjust()
	#应用特效
	#应用跨域变更

	if src.has_method(command+"_done"):
		src.call(command+"_done",src_done_arg)
	if dst.has_method(command+"_done"):
		dst.call(command+"_done",dst_done_arg)
	#上报服务器
	
func get_command_objs(command:String)->Dictionary:
	var ret:Dictionary
	match command:
		"draw":
			ret["src"]=$"../SelfHeap"
			ret["dst"]=$"../SelfHand"
			ret["src_area"]=BattleInfoMgr.BattleArea.AREA_SELF_HEAP
			ret["dst_area"]=BattleInfoMgr.BattleArea.AREA_SELF_HAND
	return ret
