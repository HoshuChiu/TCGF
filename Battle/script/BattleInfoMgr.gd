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

const HAND_ARC_CTRL=36
const HAND_OFFSET_CTRL=6
const AREA_HAND_CARD=6

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
	AREA_SELF_GRAVE,
	AREA_OPPO_HAND,
	AREA_OPPO_HEAP,
	AREA_OPPO_BATTLEFIELD,
	AREA_OPPO_CHOICE,
	AREA_OPPO_CAST,
	AREA_OPPO_WEAPON,
	AREA_OPPO_GRAVE,
	AREA_INFO
}

static func calc_card_position(area:BattleArea,slot:int)->Vector3:
	var x:float
	var y:float
	var z:float
	match area:
		BattleArea.AREA_OPPO_HEAP:
			x=9.6+slot*0.02
			y=3.2
			z=0
		BattleArea.AREA_SELF_HEAP:
			x=9.6+slot*0.02
			y=-3.2
			z=0
		BattleArea.AREA_SELF_HAND when self_card_hand_count%2==0:
			var distance=6.4/self_card_hand_count
			if distance>0.8:
				distance=0.8
			var arc:float=1.571+(distance+(self_card_hand_count/2-1)*distance*2-slot*distance*2)/HAND_ARC_CTRL
			x=HAND_ARC_CTRL*cos(arc)
			y=HAND_ARC_CTRL*sin(arc)-HAND_ARC_CTRL-HAND_OFFSET_CTRL
			z=AREA_HAND_CARD
			pass
		BattleArea.AREA_SELF_HAND when self_card_hand_count%2==1:
			var distance=6.4/self_card_hand_count
			if distance>0.8:
				distance=0.8
			var arc:float=1.571+(distance*(self_card_hand_count-1)-2*slot*distance)/HAND_ARC_CTRL
			x=HAND_ARC_CTRL*cos(arc)
			y=HAND_ARC_CTRL*sin(arc)-HAND_ARC_CTRL-HAND_OFFSET_CTRL
			z=AREA_HAND_CARD
			pass
		_:
			x=0
			y=0
	return Vector3(x,y,z)
	
static func calc_card_rotation(slot:int)->Quaternion:
	var z:float
	var distance=6.4/self_card_hand_count
	if distance>0.8:
		distance=0.8
	if self_card_hand_count%2==0:
		z=(distance+(self_card_hand_count/2-1)*distance*2-slot*distance*2)/HAND_ARC_CTRL
	else:
		z=(distance*(self_card_hand_count-1)-2*slot*distance)/HAND_ARC_CTRL
	return Quaternion.from_euler(Vector3(0,0,z))
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
