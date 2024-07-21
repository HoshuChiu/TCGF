extends Sprite3D
class_name BasicCard

@export var xxx:int=0
@export var id:int
@onready var anim_player:AnimationPlayer=AnimationPlayer.new()
@onready var anim_lib:AnimationLibrary=AnimationLibrary.new()
@onready var anim_draw:Animation=Animation.new()
@onready var bkg_pic=Sprite3D.new()

const AREA_DRAW_INFO_X:int=5
const AREA_DRAW_INFO_Y:int=-1
const AREA_DRAW_INFO_Z:int=6

#第一段spatial运动
var track_index_draw0:int
var track_index_draw1:int
var track_index_draw2:int

var track_index_draw3:int

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
	#设置抽卡第一段运动的轨道
	#track_index_draw0 = anim_draw.add_track(Animation.TYPE_POSITION_3D)
	#anim_draw.track_set_path(track_index_draw0,".")
	track_index_draw3 = anim_draw.add_track(Animation.TYPE_ROTATION_3D)
	anim_draw.track_set_path(track_index_draw3,".")
	track_index_draw0 = anim_draw.add_track(Animation.TYPE_BEZIER)
	anim_draw.track_set_path(track_index_draw0,".:position:x")
	track_index_draw1 = anim_draw.add_track(Animation.TYPE_BEZIER)
	anim_draw.track_set_path(track_index_draw1,".:position:y")
	track_index_draw2 = anim_draw.add_track(Animation.TYPE_BEZIER)
	anim_draw.track_set_path(track_index_draw2,".:position:z")
	
	anim_lib.add_animation("draw",anim_draw)
	anim_player.add_animation_library("battle",anim_lib)
	add_child(anim_player)
	
func on_draw():
	
	var anim=anim_player.get_animation("battle/draw")
	anim.bezier_track_insert_key(track_index_draw0,0.2,position.x,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw0,0.6,AREA_DRAW_INFO_X,Vector2(-0.4,0),Vector2(0.4,AREA_DRAW_INFO_X))
	anim.bezier_track_insert_key(track_index_draw1,0.2,position.y,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw1,0.6,AREA_DRAW_INFO_Y,Vector2(-0.4,0),Vector2(0.4,AREA_DRAW_INFO_X))
	anim.bezier_track_insert_key(track_index_draw2,0.0,position.z,Vector2(0,0),Vector2(0.1,0))
	anim.bezier_track_insert_key(track_index_draw2,0.6,AREA_DRAW_INFO_Z,Vector2(-0.6,0),Vector2(0.4,AREA_DRAW_INFO_X))
	#anim.position_track_insert_key(track_index_draw0,0.0,position)
	#anim.position_track_insert_key(track_index_draw0,0.2,position+Vector3(0,0,4))
	#anim.position_track_insert_key(track_index_draw0,0.2,position+Vector3(0,0,4))
	#anim.position_track_insert_key(track_index_draw0,0.4,Vector3(AREA_DRAW_INFO_X,AREA_DRAW_INFO_Y,AREA_DRAW_INFO_Z))
	anim.rotation_track_insert_key(track_index_draw3,0.1,quaternion)
	anim.rotation_track_insert_key(track_index_draw3,0.5,Quaternion.from_euler(Vector3(0,0,0)))
	anim_player.play("battle/draw")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
