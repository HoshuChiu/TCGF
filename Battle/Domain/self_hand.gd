extends Node
class_name SelfHand

var Cards:Node=Node.new()

@onready var hovered_slot:int=-1
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Cards)
	Cards.name="self_hand"
	pass # Replace with function body.

var _anim_enable:bool
var _anim_timer:float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_anim_timer+=delta
	pass

func readjust(slot:int=-1):
	for child in Cards.get_children():
		if slot!=-1&&slot!=child.slot:
			continue
		# 加上这个判断，防止在抽牌的时候发生readjust导致提前中断抽牌动画
		if child.already_in_hand:
			if(child.is_draggable() && child.is_pressed):
				continue
			child.set_render_priority(child.slot)
			var dst_pos=placement(child.slot)[0]
			var dst_qua=placement(child.slot)[1]
			var tween=child.tween
			if tween:
				tween.kill()
			tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(child.CardInfo, "position", dst_pos, 0.1).from_current()
			tween.tween_property(child.CardInfo, "rotation", dst_qua, 0.1).from_current()
			child.tween=tween
			child.draw_done(null)
	pass

func placement(slot:int)->Array[Vector3]:
	var self_card_hand_count=Cards.get_child_count()
	var x1:float
	var y1:float
	var z1:float
	var x2:float=0
	var y2:float=0
	var z2:float
	
	var space=GraphicCtrl.HANDCARD_SPACE_CTRL/self_card_hand_count
	if space>GraphicCtrl.HANDCARD_MAX_SPACE:
		space=GraphicCtrl.HANDCARD_MAX_SPACE
		
	if self_card_hand_count%2==0:
		var arc:float=1.571+(space+(self_card_hand_count/2-1)*space*2-slot*space*2)/GraphicCtrl.HANDCARD_ARC_R
		x1=GraphicCtrl.HANDCARD_ARC_R*cos(arc)
		y1=GraphicCtrl.HANDCARD_ARC_R*sin(arc)-GraphicCtrl.HANDCARD_Y_OFFSET
		z1=GraphicCtrl.HANDCARD_Z_OFFSET+GraphicCtrl.CARD_THICKNESS*slot
		z2=(space+(self_card_hand_count/2-1)*space*2-slot*space*2)/GraphicCtrl.HANDCARD_ARC_R
	else:
		var arc:float=1.571+(space*(self_card_hand_count-1)-2*slot*space)/GraphicCtrl.HANDCARD_ARC_R
		x1=GraphicCtrl.HANDCARD_ARC_R*cos(arc)
		y1=GraphicCtrl.HANDCARD_ARC_R*sin(arc)-GraphicCtrl.HANDCARD_Y_OFFSET
		z1=GraphicCtrl.HANDCARD_Z_OFFSET+GraphicCtrl.CARD_THICKNESS*slot
		z2=(space*(self_card_hand_count-1)-2*slot*space)/GraphicCtrl.HANDCARD_ARC_R
	return [Vector3(x1,y1,z1),Vector3(x2,y2,z2)]
