extends Node
class_name Superdomain

@onready var anims:Anims=Anims.new()

func init():
	pass

func regdomain(name:String):
	pass

func domain(name:String)->Node:
	return get_node(name)
	
func draw(pack:String,id:int):
	var self_heap=domain("self_heap")
	var self_hand=domain("self_hand")
	var card=CardLoader.load_card(pack,id)
	card.slot=self_hand.Cards.get_child_count()
	var plc=self_heap.placement(self_heap.Cards.get_child_count())
	card.CardInfo.position=plc[0]
	card.CardInfo.rotation=plc[1]
	self_hand.Cards.add_child(card)
	exec_command("draw",card,card.slot,null,null,null,null,null,card.CardInfo,null,null)
	self_heap.Cards.remove_child(self_heap.Cards.get_child(0))
	
func setdomain(domain:String,cards:Array[BasicCard]):
	var d=domain(domain)
	var i=0
	for card in cards:
		d.Cards.add_child(card)
		var plc=d.placement(i)
		card.position=plc[0]
		card.rotation=plc[1]
		i+=1

func play():
	print("play")

func exec_command(
	command:String,
	card:Node,
	dst_slot:int,
	card_on_arg:Variant,
	cardext_on_arg:Variant,
	src_on_arg:Variant,
	dst_on_arg:Variant,
	card_done_arg:Variant,
	op_node:Node,
	src_done_arg:Variant,
	dst_done_arg:Variant):
	var command_objs=get_command_objs(command)
	var src_name:String=command_objs["src"]
	var dst_name:String=command_objs["dst"]
	var src:Node=domain(src_name)
	var dst:Node=domain(dst_name)
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
	var plc=dst.placement(dst_slot)
	var dst_pos=plc[0]
	var dst_rot=plc[1]
	if card.has_method(command):
		card.call(command,card.apply_anim(command,card_done_arg,op_node),dst_pos,dst_rot)
		
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
			ret["src"]="self_heap"
			ret["dst"]="self_hand"
	return ret
