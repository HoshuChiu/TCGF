extends Sprite3D
class_name BasicCard

@export var xxx:int=0
@export var id:int
@onready var anim_player:AnimationPlayer=AnimationPlayer.new()
@onready var anim_lib:AnimationLibrary=AnimationLibrary.new()
@onready var anim_draw:Animation=Animation.new()
@onready var anim_adjust:Animation=Animation.new()
@onready var bkg_pic=Sprite3D.new()

# 抽卡展示区的位置
const AREA_DRAW_INFO_X:int=5
const AREA_DRAW_INFO_Y:int=-1
const AREA_DRAW_INFO_Z:int=6

#spatial运动
var track_index_draw0:int
var track_index_draw1:int
var track_index_draw2:int
#angular运动
var track_index_draw3:int

#ajdust动画
var track_index_adjust1:int
var track_index_adjust2:int

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
	
	anim_player.add_animation_library("battle",anim_lib)
	add_child(anim_player)
	
func on_draw():
	var anim=anim_player.get_animation("battle/draw")
	# 到信息展示区
	anim.bezier_track_insert_key(track_index_draw0,0.2,position.x,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw0,0.6,AREA_DRAW_INFO_X,Vector2(-0.4,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw1,0.2,position.y,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw1,0.6,AREA_DRAW_INFO_Y,Vector2(-0.4,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw2,0.0,position.z,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw2,0.6,AREA_DRAW_INFO_Z,Vector2(-0.6,0),Vector2(0,0))
	#anim.position_track_insert_key(track_index_draw0,0.0,position)
	#anim.position_track_insert_key(track_index_draw0,0.2,position+Vector3(0,0,4))
	#anim.position_track_insert_key(track_index_draw0,0.2,position+Vector3(0,0,4))
	#anim.position_track_insert_key(track_index_draw0,0.4,Vector3(AREA_DRAW_INFO_X,AREA_DRAW_INFO_Y,AREA_DRAW_INFO_Z))
	anim.rotation_track_insert_key(track_index_draw3,0.1,quaternion)
	anim.rotation_track_insert_key(track_index_draw3,0.5,Quaternion.from_euler(Vector3(0,0,0)))
	
	# 到手牌
	var pos_in_hand=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,BattleInfoMgr.self_card_hand_count-1)
	anim.bezier_track_insert_key(track_index_draw0,0.7,AREA_DRAW_INFO_X,Vector2(0,0),Vector2(0.2,0))
	anim.bezier_track_insert_key(track_index_draw0,1,pos_in_hand.x,Vector2(0.2,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw1,0.7,AREA_DRAW_INFO_Y,Vector2(0,0),Vector2(0.2,0))
	anim.bezier_track_insert_key(track_index_draw1,1,pos_in_hand.y,Vector2(0.2,0),Vector2(0,0))
	anim.bezier_track_insert_key(track_index_draw2,0.7,AREA_DRAW_INFO_Z,Vector2(0,0),Vector2(0.2,0))
	anim.bezier_track_insert_key(track_index_draw2,1,pos_in_hand.z,Vector2(0.2,0),Vector2(0,0))
	anim.rotation_track_insert_key(track_index_draw3,0.7,Quaternion.from_euler(Vector3(0,0,0)))
	anim.rotation_track_insert_key(track_index_draw3,1,BattleInfoMgr.calc_card_rotation(BattleInfoMgr.self_card_hand_count-1))
	anim_player.play("battle/draw")

func on_adjust(dest_slot:int):
	var anim=anim_player.get_animation("battle/adjust")
	var dst_pos=BattleInfoMgr.calc_card_position(BattleInfoMgr.BattleArea.AREA_SELF_HAND,dest_slot)
	var dst_qua=BattleInfoMgr.calc_card_rotation(dest_slot)
	anim.position_track_insert_key(track_index_adjust1,0,position)
	anim.position_track_insert_key(track_index_adjust1,0.15,dst_pos)
	anim.rotation_track_insert_key(track_index_adjust2,0,Quaternion.from_euler(rotation))
	anim.rotation_track_insert_key(track_index_adjust2,0.15,dst_qua)
	anim_player.play("battle/adjust")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
