extends Node
class_name Superdomain

func init():
	pass

func regdomain(name:String):
	pass

#根据名字获取区域的对象实例
func domain(name:String)->Node:
	return get_node(name)

#抽牌动作入口
func draw(pack:String,id:int):
	var self_heap=domain("self_heap")
	var self_hand=domain("self_hand")
	var card=CardLoader.load_card(pack,id)
	card.slot=self_hand.Cards.get_child_count()
	var plc=self_heap.placement(self_heap.Cards.get_child_count())
	card.CardInfo.position=plc[0]
	card.CardInfo.rotation=plc[1]
	self_hand.Cards.add_child(card)
	exec_anim("draw",card,card.slot,self_heap,self_hand,null,null,null,null,null,card.CardInfo,null,null)
	self_heap.Cards.remove_child(self_heap.Cards.get_child(0))

#设置区域动作入口
func setdomain(domain:String,cards:Array[BasicCard]):
	var d=domain(domain)
	var i=0
	for card in cards:
		d.Cards.add_child(card)
		var plc=d.placement(i)
		card.position=plc[0]
		card.rotation=plc[1]
		i+=1

#打出动作入口
func play():
	print("play")

#动画执行流程中统一的部分
func exec_anim(
	command:String,
	card:Node,
	dst_slot:int,
	src:Node,
	dst:Node,
	card_on_arg:Variant,
	cardext_on_arg:Variant,
	src_on_arg:Variant,
	dst_on_arg:Variant,
	card_done_arg:Variant,
	op_node:Node,
	src_done_arg:Variant,
	dst_done_arg:Variant):
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
	
