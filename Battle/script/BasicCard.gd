extends Node3D
class_name BasicCard
enum CardType{
	MINION,
	SPELL,
	WEAPON,
	CONSTRUCT,
	OTHER
}

enum Job{
	NEUTRAL,
	PALADIN,
	MAGE,
	PRIEST,
	DEMON,
	ASSASSIN
}

#卡牌属性
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
@export var job:Job

#实时战斗属性
var health_max:int
var current_melee_atk:int
var current_ranged_atk:int
var current_health:int
var shield:bool #由于具有圣盾的卡牌在手牌中时不需要有额外的视觉效果，所以放在实时战斗属性中

var slot:int=-1
@onready var anim_player:AnimationPlayer=AnimationPlayer.new()#暂时没用到
@onready var anim_lib:AnimationLibrary=AnimationLibrary.new()#暂时没用到
@onready var collision_shape:BoxShape3D=BoxShape3D.new()#碰撞检测体，用于检测鼠标是否在物体上，对应到一张卡片的每种形态
@onready var collision_obj:Area3D=Area3D.new()#这个是多个碰撞检测体的集合，对应到每张卡牌

var CardInfo:Sprite3D=Sprite3D.new()#卡牌形态
var Minion:Sprite3D#随从形态，在抽到时，如果该卡牌是随从牌，则会被初始化
var tween:Tween#动画执行体，通过操作此变量来控制关键帧
var hovering_obj:Node3D#此变量由操作控制器控制，表示鼠标悬浮在哪一个形态上
var already_in_hand:bool#此变量是为了避免抽牌时触发的重排使抽牌动画被直接终止，参考SelfHand.gd中的readjust函数
var mouse_pos:Vector3#鼠标视线Raycast和碰撞体的碰撞点
var is_pressed:bool#鼠标是否被点击，由操作控制器控制
var mouse_anchor:Vector3#鼠标锚点，鼠标左键按下时被设定为当时的mouse_pos
var pos_anc_diff:Vector3#鼠标锚点和卡牌位置的向量差，用于拖拽时计算卡牌的位置

func _init(id:int=0):
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = preload("res://Sketch/card_fg_minion_0.png") as Texture
	#初始化卡牌形态
	add_child(CardInfo)
	CardInfo.name="card_info"
	CardInfo.texture=texture
	var bkg_pic:Sprite3D=Sprite3D.new()
	bkg_pic.position=Vector3(0,0,-0.01)
	bkg_pic.rotate_y(3.14159)
	texture=preload("res://Sketch/card_bkg_0.png") as Texture
	bkg_pic.texture=texture
	CardInfo.add_child(bkg_pic)
	#初始化卡牌形态的碰撞体
	collision_shape.size=Vector3(GraphicCtrl.CARD_WIDTH_M,GraphicCtrl.CARD_HEIGHT_M+5,0.01)
	collision_obj.shape_owner_add_shape(collision_obj.create_shape_owner(CardInfo),collision_shape)
	collision_obj.position=Vector3(0,-2.5,0)
	collision_obj.shape_owner_set_disabled(0,true)
	CardInfo.add_child(collision_obj)
	#初始化卡牌上的文字
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
	
	#这个动画播放器是用来播放固定动画，即关键帧的参数无法被外部变量所控制的动画，暂时用不着
	anim_player.add_animation_library("battle",anim_lib)
	add_child(anim_player)

#设置渲染优先级，每一个slot占两个优先级，控制卡牌重叠时优先显示哪一个卡牌，手牌中时从左到右依次+2
func set_render_priority(priority:int):
	CardInfo.render_priority=priority*2
	for c in CardInfo.get_children():
		if c is Label3D:
			c.render_priority=priority*2+1

#鼠标放在卡牌上时触发，查看卡牌
func _show():
	set_render_priority(GraphicCtrl.HANDCARD_MAX_PRIORITY)
	var x:float=((GraphicCtrl.CAMERA_HEIGHT-GraphicCtrl.INFOCARD_HEIGHT)*1.0/GraphicCtrl.CAMERA_HEIGHT)*hovering_obj.position.x
	
	if tween:
		if tween.is_running():
			return
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(CardInfo, "position", Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT), 0.02)
	tween.tween_property(CardInfo, "rotation", Vector3(0,0,0), 0.01)

#鼠标进入卡牌时
func mouse_enter():
	match get_parent().name:
		"self_hand":
			_show()
	pass

#鼠标离开卡牌时
func mouse_exit():
	is_pressed=false
	_lose_focus()

#鼠标左键按下卡牌时
func mouse_press():
	is_pressed=true
	mouse_anchor=mouse_pos
	pos_anc_diff=mouse_anchor-CardInfo.position
	if is_draggable():
		collision_shape.size=Vector3(50,50,0.01)


#鼠标左键松开时
func mouse_release():
	is_pressed=false
	if is_draggable():
		collision_shape.size=Vector3(GraphicCtrl.CARD_WIDTH_M,GraphicCtrl.CARD_HEIGHT_M+5,0.01)
	_lose_focus()
	#TODO:判断松手时条件
	$"/root/Battle/Superdomain".play()

#鼠标悬浮在卡牌上时，每帧都会调用
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
	if tween:
		tween.kill()

#鼠标拖动时，每帧都会调用
func _dragging():
	if is_draggable():
		var mouse_pos_adj=(GraphicCtrl.CAMERA_HEIGHT-1)/(GraphicCtrl.CAMERA_HEIGHT-mouse_pos.z)*(mouse_pos-GraphicCtrl.CAMERA_POS)+GraphicCtrl.CAMERA_POS
		var to_pos=mouse_pos_adj-pos_anc_diff
		var vect=to_pos-GraphicCtrl.CAMERA_POS
		CardInfo.position=to_pos#+vect.normalized()*GraphicCtrl.HANDCARD_PUSH_SCALAR
		#position.z=GraphicCtrl.INFOCARD_HEIGHT-2
	pass
	
#限定拖拽条件，TODO:这个函数以后可能会大改，但是调用它的地方的逻辑是不变的
func is_draggable()->bool:
	#TODO:增加判断条件
	if get_parent().name=="self_hand":
		return true
	else:
		return false

#预留的函数
func _lose_focus():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#获取补间动画播放器，并设定回调函数，此函数被Superdomain.gd调用
func apply_anim(command:String,args:Variant,node:Node)->Tween:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_callback(anim_callback.bind(command,args))
	return tween

func anim_callback(command:String,args:Variant):
	if has_method(command+"_done"):
		call(command+"_done",args)

func on_draw(args):
	if type==0: #说明是随从
		#初始化随从形态
		Minion=Sprite3D.new()
		add_child(Minion)
		Minion.texture=preload("res://Sketch/card_fg_minion_0.png")
		Minion.hide()

#设定抽牌时的动画的Key帧
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

#抽完牌时的回调函数，抽完牌后把碰撞体打开，使得鼠标可以跟卡牌开始交互
func draw_done(args):
	already_in_hand=true
	collision_obj.shape_owner_set_disabled(0,false)
