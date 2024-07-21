extends Node3D
class_name BF

@export var x2=1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MainCamera.position=Vector3(0,0,35)
	
	# TODO:Get Battle Infomations
	BattleInfoMgr.init_battle("我是你爹","我也是你爹",1,2)
	# 
	
	for i in range(0,BattleInfoMgr.self_card_heap_count):
		var card=BasicCard.new(0)
		#var card = card_res.instantiate()
		
		
		card.rotate_y(1.57)
		card.rotate_x(1.57)
		card.position=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HEAP,i)
		$SelfHeap.add_child(card)
	
	for i in range(0,BattleInfoMgr.oppo_card_heap_count):
		var card=BasicCard.new(0)
		card.rotate_y(1.57)
		card.rotate_x(1.57)
		card.position=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_OPPO_HEAP,i)
		$OppoHeap.add_child(card)
	
	BattleInfoMgr.self_card_hand_count=3
	for i in range(0,BattleInfoMgr.self_card_hand_count):
		var card=BasicCard.new(0)
		card.position=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,i)
		card.rotation=BattleInfoMgr.calc_card_rotation(i).get_euler()
		card.render_priority=0
		print(card.position)
		$SelfHand.add_child(card)
	#Animation

func draw_card():
	var card:BasicCard=$SelfHeap.get_child(0)
	$SelfHeap.remove_child(card)
	$SelfHand.add_child(card)
	$SelfHand.repos_hand_cards(1,BattleInfoMgr.self_card_hand_count)
	
	card.on_draw()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_anm(self_name:String,oppo_name:String):
	pass
