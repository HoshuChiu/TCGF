extends Node3D
class_name BF

@export var x2=1
signal mouse_left_press
signal mouse_left_release

var domains:Node
# Called when the node enters the scene tree for the first time.
func draw_test():
	var pack:String=$TextEdit.text
	var id:String=$TextEdit2.text
	$Superdomain.draw(pack,id.to_int())
func _ready():
	$MainCamera.position=Vector3(0,GraphicCtrl.CAMERA_Y_OFFSET,GraphicCtrl.CAMERA_HEIGHT)
	
	#domains.name=""
	# TODO:Get Battle Infomations
	BattleInfoMgr.init_battle("我是你爹","我也是你爹",1,2)
	# 
	
	
	var cards_s:Array[BasicCard]
	for i in range(0,BattleInfoMgr.self_card_heap_count):
		cards_s.append(BasicCard.new())
	$Superdomain.setdomain("self_heap",cards_s)
		
	var cards_o:Array[BasicCard]
	for i in range(0,BattleInfoMgr.oppo_card_heap_count):
		cards_o.append(BasicCard.new())
	$Superdomain.setdomain("oppo_heap",cards_o)
	
	#Animation
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hover_timer+=delta
	pass

const RAY_LENGTH = 200

var hovering_card:BasicCard
@onready var hover_action_enable:bool=true
@onready var hover_timer:float=0
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
		#if(card.area==BattleInfoMgr.BattleArea.AREA_SELF_HAND):
			#$SelfHand.on_card_hovered(card.slot)
			#card.on_hover()
			#card.mouse_pos=result["position"]
		if card == hovering_card:
			card.mouse_pos=result["position"]
			card._hover()
		elif hover_action_enable:
		#else:
			if hovering_card:
				hovering_card._adjust(hovering_card.slot)
				#TODO:取消hoveringcard的信号
				disconnect("mouse_left_press",hovering_card.mouse_press)
				disconnect("mouse_left_release",hovering_card.mouse_release)
				hovering_card.mouse_exit()
			card.mouse_enter()
			hovering_card=card
			connect("mouse_left_press",card.mouse_press)
			connect("mouse_left_release",card.mouse_release)
			hover_action_enable=false
			hover_timer=0
		else:
			if hover_timer>0.01:
				hover_action_enable=true
	else:
		if hovering_card:
			if hover_action_enable:
				hovering_card._adjust(hovering_card.slot)
				#TODO:取消hoveringcard的信号
				disconnect("mouse_left_press",hovering_card.mouse_press)
				disconnect("mouse_left_release",hovering_card.mouse_release)
				hovering_card.mouse_exit()
				hovering_card=null
				hover_action_enable=false
				hover_timer=0
			elif hover_timer>0.01:
				hover_action_enable=true
		pass

func _input(event):
	if event is InputEventMouseButton:  
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:  
				emit_signal("mouse_left_press")
			else:
				emit_signal("mouse_left_release")
