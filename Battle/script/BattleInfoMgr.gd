extends Object
class_name BattleInfoMgr

var extension_code:String

static var self_name:String
static var oppo_name:String
static var self_job_name:String
static var oppo_job_name:String

static var self_card_heap_count:int
static var oppo_card_heap_count:int
static var self_card_hand_count:int
static var oppo_card_hand_count:int
static var self_card_heap_max:int
static var oppo_card_heap_max:int
static var self_card_hand_max:int
static var oppo_card_hand_max:int

const AREA_HAND_CARD=0

func _init(self_name:String,oppo_name:String,self_job:int,oppo_job:int,self_card_count:int=30,oppo_card_count:int=30):
	pass

static func init_battle(self_name:String,oppo_name:String,self_job:int,oppo_job:int,self_card_count:int=30,oppo_card_count:int=30):
	BattleInfoMgr.self_name=self_name
	BattleInfoMgr.oppo_name=oppo_name
	BattleInfoMgr.self_job_name=_get_job_name(self_job)
	BattleInfoMgr.oppo_job_name=_get_job_name(oppo_job)
	BattleInfoMgr.self_card_hand_count=0
	BattleInfoMgr.self_card_heap_count=self_card_count
	BattleInfoMgr.self_card_hand_max=_get_hand_max_initial()
	BattleInfoMgr.self_card_heap_max=_get_heap_max_initial()
	BattleInfoMgr.oppo_card_hand_count=0
	BattleInfoMgr.oppo_card_heap_count=oppo_card_count
	BattleInfoMgr.oppo_card_hand_max=_get_hand_max_initial()
	BattleInfoMgr.oppo_card_heap_max=_get_heap_max_initial()
	
enum BattleArea{
	AREA_VOID,
	AREA_SELF_HAND,
	AREA_SELF_HEAP,
	AREA_SELF_BATTLEFIELD,
	AREA_SELF_CHOICE,
	AREA_SELF_CAST,
	AREA_SELF_WEAPON,
	AREA_SELF_SECRET,
	AREA_SELF_GRAVE,
	AREA_OPPO_HAND,
	AREA_OPPO_HEAP,
	AREA_OPPO_BATTLEFIELD,
	AREA_OPPO_CHOICE,
	AREA_OPPO_CAST,
	AREA_OPPO_WEAPON,
	AREA_OPPO_SECRET,
	AREA_OPPO_GRAVE,
	AREA_INFO
}

static func calc_card_position(area:BattleArea,slot:int)->Vector3:
	var x:float
	var y:float
	var z:float
	match area:
		BattleArea.AREA_OPPO_HEAP:
			x=GraphicCtrl.HEAPCARD_X_OFFSET+slot*GraphicCtrl.CARD_THICKNESS
			y=GraphicCtrl.HEAPCARD_Y_OFFSET
			z=GraphicCtrl.HEAPCARD_Z_OFFSET
		BattleArea.AREA_SELF_HEAP:
			x=GraphicCtrl.HEAPCARD_X_OFFSET+slot*GraphicCtrl.CARD_THICKNESS
			y=-GraphicCtrl.HEAPCARD_Y_OFFSET
			z=GraphicCtrl.HEAPCARD_Z_OFFSET
		BattleArea.AREA_SELF_HAND when self_card_hand_count%2==0:
			var space=GraphicCtrl.HANDCARD_SPACE_CTRL/self_card_hand_count
			if space>GraphicCtrl.HANDCARD_MAX_SPACE:
				space=GraphicCtrl.HANDCARD_MAX_SPACE
			var arc:float=1.571+(space+(self_card_hand_count/2-1)*space*2-slot*space*2)/GraphicCtrl.HANDCARD_ARC_R
			x=GraphicCtrl.HANDCARD_ARC_R*cos(arc)
			y=GraphicCtrl.HANDCARD_ARC_R*sin(arc)-GraphicCtrl.HANDCARD_Y_OFFSET
			z=GraphicCtrl.HANDCARD_Z_OFFSET+GraphicCtrl.CARD_THICKNESS*slot
			pass
		BattleArea.AREA_SELF_HAND when self_card_hand_count%2==1:
			var space=GraphicCtrl.HANDCARD_SPACE_CTRL/self_card_hand_count
			if space>GraphicCtrl.HANDCARD_MAX_SPACE:
				space=GraphicCtrl.HANDCARD_MAX_SPACE
			var arc:float=1.571+(space*(self_card_hand_count-1)-2*slot*space)/GraphicCtrl.HANDCARD_ARC_R
			x=GraphicCtrl.HANDCARD_ARC_R*cos(arc)
			y=GraphicCtrl.HANDCARD_ARC_R*sin(arc)-GraphicCtrl.HANDCARD_Y_OFFSET
			z=GraphicCtrl.HANDCARD_Z_OFFSET+GraphicCtrl.CARD_THICKNESS*slot
			pass
		_:
			x=0
			y=0
	return Vector3(x,y,z)
	
static func calc_card_rotation(area:BattleArea,slot:int)->Vector3:
	var x:float=0
	var y:float=0
	var z:float=0
	match area:
		BattleArea.AREA_OPPO_HEAP:
			y=1.57
			z=1.57
		BattleArea.AREA_SELF_HEAP:
			y=1.57
			z=1.57
		BattleArea.AREA_SELF_HAND:
			var space=GraphicCtrl.HANDCARD_SPACE_CTRL/self_card_hand_count
			if space>GraphicCtrl.HANDCARD_MAX_SPACE:
				space=GraphicCtrl.HANDCARD_MAX_SPACE
			if self_card_hand_count%2==0:
				z=(space+(self_card_hand_count/2-1)*space*2-slot*space*2)/GraphicCtrl.HANDCARD_ARC_R
			else:
				z=(space*(self_card_hand_count-1)-2*slot*space)/GraphicCtrl.HANDCARD_ARC_R
	return Vector3(x,y,z)
# TODO: 动态改变
static func _get_job_name(job_id:int)->String:
	match job_id:
		1:
			return "骑士"
		2:
			return "法师"
		3:
			return "牧师"
		4:
			return "恶魔"
		5:
			return "影剑士"
		_:
			return "未知"

# TODO: 动态改变
static func _get_hand_max_initial()->int:
	return 10

# TODO: 动态改变
static func _get_heap_max_initial()->int:
	return 60
