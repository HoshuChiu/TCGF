extends Sprite3D
class_name BasicCard

@export var id:int
@onready var slot:int=-1
@onready var anim_player:AnimationPlayer=AnimationPlayer.new()
@onready var anim_lib:AnimationLibrary=AnimationLibrary.new()
@onready var anim_draw:Animation=Animation.new()
@onready var anim_adjust:Animation=Animation.new()
@onready var anim_show:Animation=Animation.new()
@onready var bkg_pic=Sprite3D.new()
@onready var collision_shape:BoxShape3D=BoxShape3D.new()
@onready var collision_obj:CardArea=CardArea.new()
@onready var area:BattleInfoMgr.BattleArea=BattleInfoMgr.BattleArea.AREA_VOID

class CardArea extends Area3D:
	func _mouse_enter():
		var card:BasicCard=shape_owner_get_owner(0)
		#if(card.slot!=-1):
			#card.on_show()

	func _mouse_exit():
		var card:BasicCard=shape_owner_get_owner(0)
		#if(card.slot!=-1):
			#card.on_adjust(card.slot)


#spatial运动
var track_index_draw0:int
var track_index_draw1:int
var track_index_draw2:int
#angular运动
var track_index_draw3:int

#ajdust动画
var track_index_adjust1:int
var track_index_adjust2:int
#show动画
var track_index_show1:int
var track_index_show2:int

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
	collision_shape.size=Vector3(GraphicCtrl.CARD_WIDTH_M,GraphicCtrl.CARD_HEIGHT_M,0.01)
	collision_obj.shape_owner_add_shape(collision_obj.create_shape_owner(self),collision_shape)
	collision_obj.position=Vector3(0,0,0)
	add_child(collision_obj)
	#Animation
	track_index_draw3 = anim_draw.add_track(Animation.TYPE_ROTATION_3D)
	anim_draw.track_set_path(track_index_draw3,".")
	track_index_draw0 = anim_draw.add_track(Animation.TYPE_BEZIER)
	anim_draw.track_set_path(track_index_draw0,".:position:x")
	track_index_draw1 = anim_draw.add_track(Animation.TYPE_BEZIER)
	anim_draw.track_set_path(track_index_draw1,".:position:y")
	track_index_draw2 = anim_draw.add_track(Animation.TYPE_BEZIER)
	anim_draw.track_set_path(track_index_draw2,".:position:z")
	
	anim_lib.add_animation("draw",anim_draw)
	
	track_index_adjust1=anim_adjust.add_track(Animation.TYPE_POSITION_3D)
	anim_adjust.track_set_path(track_index_adjust1,".")
	track_index_adjust2=anim_adjust.add_track(Animation.TYPE_ROTATION_3D)
	anim_adjust.track_set_path(track_index_adjust2,".")
	anim_lib.add_animation("adjust",anim_adjust)
	
	track_index_show1=anim_show.add_track(Animation.TYPE_POSITION_3D)
	anim_show.track_set_path(track_index_show1,".")
	track_index_show2=anim_show.add_track(Animation.TYPE_ROTATION_3D)
	anim_show.track_set_path(track_index_show2,".")
	anim_lib.add_animation("show",anim_show)
	
	anim_player.add_animation_library("battle",anim_lib)
	add_child(anim_player)
	
func on_draw():
	slot=BattleInfoMgr.self_card_hand_count-1
	render_priority=slot
	area=BattleInfoMgr.BattleArea.AREA_SELF_HAND
	var anim=anim_player.get_animation("battle/draw")
	# 到信息展示区
	anim.bezier_track_insert_key(track_index_draw0,0.2,position.x,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw0,0.6,GraphicCtrl.INFOCARD_DRAW_X_OFFSET,Vector2(-0.4,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw1,0.2,position.y,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw1,0.6,GraphicCtrl.INFOCARD_DRAW_Y_OFFSET,Vector2(-0.4,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw2,0.0,position.z,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw2,0.6,GraphicCtrl.INFOCARD_HEIGHT,Vector2(-0.6,0),Vector2(0,0))
	anim.rotation_track_insert_key(track_index_draw3,0.1,quaternion)
	anim.rotation_track_insert_key(track_index_draw3,0.5,Quaternion.from_euler(Vector3(0,0,0)))
	
	# 到手牌
	var pos_in_hand=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,slot)
	anim.bezier_track_insert_key(track_index_draw0,0.7,GraphicCtrl.INFOCARD_DRAW_X_OFFSET,Vector2(0,0),Vector2(0.2,0))
	anim.bezier_track_insert_key(track_index_draw0,1,pos_in_hand.x,Vector2(0.2,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw1,0.7,GraphicCtrl.INFOCARD_DRAW_Y_OFFSET,Vector2(0,0),Vector2(0.2,0))
	anim.bezier_track_insert_key(track_index_draw1,1,pos_in_hand.y,Vector2(0.2,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw2,0.7,GraphicCtrl.INFOCARD_HEIGHT,Vector2(0,0),Vector2(0.2,0))
	anim.bezier_track_insert_key(track_index_draw2,1,pos_in_hand.z,Vector2(0.2,0),Vector2(0,0))
	anim.rotation_track_insert_key(track_index_draw3,0.7,Quaternion.from_euler(Vector3(0,0,0)))
	anim.rotation_track_insert_key(track_index_draw3,1,BattleInfoMgr.calc_card_rotation(slot))
	anim_player.play("battle/draw")

func on_adjust(dest_slot:int):
	slot=dest_slot
	render_priority=slot
	var anim=anim_player.get_animation("battle/adjust")
	var dst_pos=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,slot)
	var dst_qua=BattleInfoMgr.calc_card_rotation(slot)
	anim.position_track_insert_key(track_index_adjust1,0,position)
	anim.position_track_insert_key(track_index_adjust1,0.1,dst_pos)
	anim.rotation_track_insert_key(track_index_adjust2,0,Quaternion.from_euler(rotation))
	anim.rotation_track_insert_key(track_index_adjust2,0.1,dst_qua)
	anim_player.play("battle/adjust")
	pass

func on_show():
	render_priority=GraphicCtrl.HANDCARD_MAX_PRIORITY
	var anim=anim_player.get_animation("battle/show")
	var x:float=((GraphicCtrl.CAMERA_HEIGHT-GraphicCtrl.INFOCARD_HEIGHT)*1.0/GraphicCtrl.CAMERA_HEIGHT)*position.x
	anim.position_track_insert_key(track_index_show1,0,position)
	anim.position_track_insert_key(track_index_show1,0.01,Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT))
	anim.rotation_track_insert_key(track_index_show2,0,Quaternion.from_euler(rotation))
	anim.rotation_track_insert_key(track_index_show2,0.01,Quaternion.from_euler(Vector3(0,0,0)))
	anim_player.play("battle/show")
	#position=Vector3(x,GraphicCtrl.INFOCARD_INHAND_Y_OFFSET,GraphicCtrl.INFOCARD_HEIGHT)
	#rotation=Vector3(0,0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
