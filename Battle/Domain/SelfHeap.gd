extends Node
class_name SelfHeap

var Cards:Node=Node.new()

func _ready():
	add_child(Cards)
	Cards.name="self_heap"

func placement(slot:int)->Array[Vector3]:
	var x1:float=GraphicCtrl.HEAPCARD_X_OFFSET+slot*GraphicCtrl.CARD_THICKNESS
	var y1:float=-GraphicCtrl.HEAPCARD_Y_OFFSET
	var z1:float=GraphicCtrl.HEAPCARD_Z_OFFSET
	var x2:float=0
	var y2:float=1.57
	var z2:float=1.57
	return [Vector3(x1,y1,z1),Vector3(x2,y2,z2)]
