extends Node3D
class_name BF

@export var x2=1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MainCamera.position=Vector3(0,GraphicCtrl.CAMERA_Y_OFFSET,GraphicCtrl.CAMERA_HEIGHT)
	
	# TODO:Get Battle Infomations
	BattleInfoMgr.init_battle("我是你爹","我也是你爹",1,2)
	# 
	
	for i in range(0,BattleInfoMgr.self_card_heap_count):
		var card=BasicCard.new(0)
		card.rotate_y(1.57)
		card.rotate_x(1.57)
		card.position=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HEAP,i)
		card.area=BattleInfoMgr.BattleArea.AREA_SELF_HEAP
		$SelfHeap.add_child(card)
	
	for i in range(0,BattleInfoMgr.oppo_card_heap_count):
		var card=BasicCard.new(0)
		card.rotate_y(1.57)
		card.rotate_x(1.57)
		card.position=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_OPPO_HEAP,i)
		card.area=BattleInfoMgr.BattleArea.AREA_OPPO_HEAP
		$OppoHeap.add_child(card)
	
	#Animation

func draw_card():
	var card:BasicCard=$SelfHeap.get_child(0)
	$SelfHeap.remove_child(card)
	$SelfHand.repos_hand_cards(1,BattleInfoMgr.self_card_hand_count-1)
	$SelfHand.add_child(card)
	card.on_draw()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const RAY_LENGTH = 200

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $MainCamera
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)+cam.project_ray_normal(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if not result.is_empty():
		var card:BasicCard=result["collider"].shape_owner_get_owner(result["shape"])
		if(card.area==BattleInfoMgr.BattleArea.AREA_SELF_HAND):
			$SelfHand.on_card_hovered(card.slot)
	else:
		$SelfHand.on_hover_cancel()
