extends Node3D
class_name BasicCard
enum CardType{
	MINION,
	SPELL,
	WEAPON,
	CONSTRUCT,
	OTHER
}

@export var id:int
@export var pack:String
@export var cost:int
@export var type:CardType
@export var melee_atk:int
@export var ranged_atk:int
@export var health:int
@export var race:String
@export var description:String
@export var card_name:String
@export var rarity:int
@export var job:int

var health_max:int
var current_melee_atk:int
var current_ranged_atk:int
var current_health:int

var slot:int=-1
@onready var anim_player:AnimationPlayer=AnimationPlayer.new()
@onready var anim_lib:AnimationLibrary=AnimationLibrary.new()
@onready var collision_shape:BoxShape3D=BoxShape3D.new()
@onready var collision_obj:Area3D=Area3D.new()

var CardInfo:Sprite3D=Sprite3D.new()
var tween:Tween
var already_in_hand:bool
var mouse_pos:Vector3
var is_pressed:bool

func _init(id:int=0):
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = preload("res://Sketch/card_fg_minion_0.png") as Texture
	add_child(CardInfo)
	CardInfo.name="card_info"
	CardInfo.texture=texture
	var bkg_pic:Sprite3D=Sprite3D.new()
	bkg_pic.position=Vector3(0,0,-0.01)
	bkg_pic.rotate_y(3.14159)
	texture=preload("res://Sketch/card_bkg_0.png") as Texture
	bkg_pic.texture=texture
	CardInfo.add_child(bkg_pic)
	#Interaction
	collision_shape.size=Vector3(GraphicCtrl.CARD_WIDTH_M,GraphicCtrl.CARD_HEIGHT_M+5,0.01)
	collision_obj.shape_owner_add_shape(collision_obj.create_shape_owner(self),collision_shape)
	collision_obj.position=Vector3(0,-2.5,0)
	collision_obj.shape_owner_set_disabled(0,true)
	CardInfo.add_child(collision_obj)
	#Labels
	var cost_label:Label3D=Label3D.new()
	var name_label:Label3D=Label3D.new()
	var atk_label:Label3D=Label3D.new()
	var health_label:Label3D=Label3D.new()
	
	cost_label.text=String.num_int64(cost)
	cost_label.font_size=90
	cost_label.position=Vector3(-GraphicCtrl.CARD_WIDTH_M/2+0.35,GraphicCtrl.CARD_HEIGHT_M/2-0.345,0.01)
	CardInfo.add_child(cost_label)
	name_label.text=card_name
	name_label.font_size=60
	name_label.position=Vector3(0,-0.15,0.01)
	CardInfo.add_child(name_label)
	atk_label.text=String.num_int64(melee_atk)
	atk_label.font_size=90
	atk_label.position=Vector3(-GraphicCtrl.CARD_WIDTH_M/2+0.3,-GraphicCtrl.CARD_HEIGHT_M/2+0.345,0.01)
	CardInfo.add_child(atk_label)
	health_label.text=String.num_int64(health)
	health_label.font_size=90
	health_label.position=Vector3(GraphicCtrl.CARD_WIDTH_M/2-0.3,-GraphicCtrl.CARD_HEIGHT_M/2+0.345,0.01)
	CardInfo.add_child(health_label)
	set_render_priority(slot)
	#Animation
	anim_player.add_animation_library("battle",anim_lib)
	add_child(anim_player)

func set_render_priority(priority:int):
	CardInfo.render_priority=priority*2
	for c in CardInfo.get_children():
		if c is Label3D:
			c.render_priority=priority*2+1

func _adjust(dest_slot:int):
	#只有在这里面可以adjust
	var area=get_parent().name
	if (area!="self_hand" &&
		area!="oppo_hand" &&
		area!="self_choice" &&
		area!="self_secret" &&
		area!="oppo_secret" &&
		area!="oppo_choice" &&
		area!="self_minion" &&
		area!="oppo_minion"
		):
		return
	if(is_draggable() && is_pressed):
		return
	slot=dest_slot
	set_render_priority(slot)
	var dst_pos=get_parent().get_parent().placement(slot)[0]
	var dst_qua=get_parent().get_parent().placement(slot)[1]
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(CardInfo, "position", dst_pos, 0.1).from_current()
	tween.tween_property(CardInfo, "rotation", dst_qua, 0.1).from_current()
	draw_done(null)
	pass
	
func _show():
	set_render_priority(GraphicCtrl.HANDCARD_MAX_PRIORITY)
	var x:float=((GraphicCtrl.CAMERA_HEIGHT-GraphicCtrl.INFOCARD_HEIGHT)*1.0/GraphicCtrl.CAMERA_HEIGHT)*position.x
	
	if tween:
		if tween.is_running():
			return
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(CardInfo, "position", Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT), 0.02)
	tween.tween_property(CardInfo, "rotation", Vector3(0,0,0), 0.01)
	
func mouse_enter():
	match get_parent().name:
		"self_hand":
			_show()
	pass
	
func mouse_exit():
	is_pressed=false
	_lose_focus()

func mouse_press():
	is_pressed=true
	mouse_anchor=mouse_pos
	pos_anc_diff=mouse_anchor-CardInfo.position
	if is_draggable():
		collision_shape.size=Vector3(50,50,0.01)
	
func mouse_release():
	is_pressed=false
	if is_draggable():
		collision_shape.size=Vector3(GraphicCtrl.CARD_WIDTH_M,GraphicCtrl.CARD_HEIGHT_M+5,0.01)
	_lose_focus()
	#TODO:判断松手时条件
	$"/root/Battlefield/Superdomain".play()

func _hover():
	#if mouse down todo:
	if is_pressed:
		_dragging()
	if get_parent().name=="self_hand" && already_in_hand&&!is_pressed:
		set_render_priority(GraphicCtrl.HANDCARD_MAX_PRIORITY)
		var xx:float=get_parent().get_parent().placement(slot)[0].x
		var x:float=((GraphicCtrl.CAMERA_HEIGHT-GraphicCtrl.INFOCARD_HEIGHT)*1.0/GraphicCtrl.CAMERA_HEIGHT)*xx
		CardInfo.position=Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT)
		CardInfo.rotation=Vector3(0,0,0)


var mouse_anchor:Vector3
var pos_anc_diff:Vector3
func _dragging():
	if is_draggable():
		var mouse_pos_adj=(GraphicCtrl.CAMERA_HEIGHT-1)/(GraphicCtrl.CAMERA_HEIGHT-mouse_pos.z)*(mouse_pos-GraphicCtrl.CAMERA_POS)+GraphicCtrl.CAMERA_POS
		var to_pos=mouse_pos_adj-pos_anc_diff
		var vect=to_pos-GraphicCtrl.CAMERA_POS
		CardInfo.position=to_pos#+vect.normalized()*GraphicCtrl.HANDCARD_PUSH_SCALAR
		#position.z=GraphicCtrl.INFOCARD_HEIGHT-2
	pass

func is_draggable()->bool:
	#TODO:增加判断条件
	if get_parent().name=="self_hand":
		return true
	else:
		return false

func _lose_focus():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_anim(command:String,args:Variant,node:Node)->Tween:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_callback(anim_callback.bind(command,args))
	return tween

func anim_callback(command:String,args:Variant):
	if has_method(command+"_done"):
		call(command+"_done",args)

func draw(tween_p:Tween,dst_pos:Vector3,dst_rot:Vector3):
	tween_p.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween_p.tween_property(CardInfo,"position",Vector3(GraphicCtrl.INFOCARD_DRAW_X_OFFSET,
													GraphicCtrl.INFOCARD_DRAW_Y_OFFSET,
													GraphicCtrl.INFOCARD_HEIGHT),0.5)
	tween_p.parallel().tween_property(CardInfo,"position:z",6,0.2)
	tween_p.parallel().tween_property(CardInfo,"rotation",Vector3(0,0,0),0.4)
	tween_p.set_ease(Tween.EASE_OUT)
	tween_p.tween_property(CardInfo,"position",dst_pos,1)
	tween_p.parallel().tween_property(CardInfo,"rotation",dst_rot,1)

func draw_done(args):
	already_in_hand=true
	collision_obj.shape_owner_set_disabled(0,false)

#func on_play(args):
#	
