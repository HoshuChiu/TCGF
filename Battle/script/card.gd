extends Sprite3D
class_name BasicCard

@export var id:int
@onready var slot:int=-1
@onready var anim_player:AnimationPlayer=AnimationPlayer.new()
@onready var anim_lib:AnimationLibrary=AnimationLibrary.new()
@onready var bkg_pic=Sprite3D.new()
@onready var collision_shape:BoxShape3D=BoxShape3D.new()
@onready var collision_obj:Area3D=Area3D.new()
@onready var area:BattleInfoMgr.BattleArea=BattleInfoMgr.BattleArea.AREA_VOID
var tween:Tween
var already_in_hand:bool
var mouse_pos:Vector3

func _init(id:int):
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	var texture = preload("res://Sketch/card_fg_minion_0.png") as Texture
	self.texture=texture
	bkg_pic.position=Vector3(0,0,-0.01)
	bkg_pic.rotate_y(3.14159)
	texture=preload("res://Sketch/card_bkg_0.png") as Texture
	bkg_pic.texture=texture
	add_child(bkg_pic)
	#Interaction
	collision_shape.size=Vector3(GraphicCtrl.CARD_WIDTH_M,GraphicCtrl.CARD_HEIGHT_M+5,0.01)
	collision_obj.shape_owner_add_shape(collision_obj.create_shape_owner(self),collision_shape)
	collision_obj.position=Vector3(0,-2.5,0)
	add_child(collision_obj)
	
	#Animation
	anim_player.add_animation_library("battle",anim_lib)
	add_child(anim_player)

func on_adjust(dest_slot:int):
	slot=dest_slot
	render_priority=slot
	var dst_pos=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,slot)
	var dst_qua=BattleInfoMgr.calc_card_rotation(BattleInfoMgr.BattleArea.AREA_SELF_HAND,slot)

	if tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", dst_pos, 0.1).from_current()
	tween.tween_property(self, "rotation", dst_qua, 0.1).from_current()
	draw_done(null)
	pass
	
func on_show():
	render_priority=GraphicCtrl.HANDCARD_MAX_PRIORITY
	var x:float=((GraphicCtrl.CAMERA_HEIGHT-GraphicCtrl.INFOCARD_HEIGHT)*1.0/GraphicCtrl.CAMERA_HEIGHT)*position.x
	
	#
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT), 0.02)
	tween.tween_property(self, "rotation", Vector3(0,0,0), 0.01)
	
func on_hover():
	#if mouse down todo:
	
	if already_in_hand:
		render_priority=GraphicCtrl.HANDCARD_MAX_PRIORITY
		var xx:float=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,slot).x
		var x:float=((GraphicCtrl.CAMERA_HEIGHT-GraphicCtrl.INFOCARD_HEIGHT)*1.0/GraphicCtrl.CAMERA_HEIGHT)*xx
		position=Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT)
		rotation=Vector3(0,0,0)
		
func on_dragging():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_anim(command:String,args:Variant)->Tween:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_callback(anim_callback.bind(command,args))
	return tween

func anim_callback(command:String,args:Variant):
	if has_method(command+"_done"):
		call(command+"_done",args)

func draw(tween_p:Tween,dst_pos:Vector3,dst_rot:Vector3):
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"position",Vector3(GraphicCtrl.INFOCARD_DRAW_X_OFFSET,
													GraphicCtrl.INFOCARD_DRAW_Y_OFFSET,
													GraphicCtrl.INFOCARD_HEIGHT),0.5)
	tween.parallel().tween_property(self,"position:z",6,0.2)
	tween.parallel().tween_property(self,"rotation",Vector3(0,0,0),0.4)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position",dst_pos,1)
	tween.parallel().tween_property(self,"rotation",dst_rot,1)

func on_draw(arg):
	slot=arg
	render_priority=arg
	area=BattleInfoMgr.BattleArea.AREA_SELF_HAND

func draw_done(args):
	already_in_hand=true
