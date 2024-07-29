extends Node
class_name SelfMinion

var Cards:Node=Node.new()

func _ready():
	add_child(Cards)
	Cards.name="self_minion"

func placement(slot:int)->Array[Vector3]:
	var x1:float=0
	var y1:float=0
	var z1:float=0
	var x2:float=0
	var y2:float=0
	var z2:float=0
	return [Vector3(x1,y1,z1),Vector3(x2,y2,z2)]
