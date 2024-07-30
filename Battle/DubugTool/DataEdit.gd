extends TextEdit
class_name DataEdit

enum datatype{
	ID,
	NAME,
	CUSTOM_TSCN,
	COST,
	MELEE_ATK,
	RANGED_ATK,
	HEALTH,
	RACE
}

var value:Variant
var data_type:datatype

func _init(type:datatype,val:Variant=null):
	data_type=type
	custom_minimum_size.x=60
	match type:
		datatype.ID:
			name="id"
			custom_minimum_size.x=80
		datatype.NAME:
			name="name"
			custom_minimum_size.x=80
		datatype.CUSTOM_TSCN:
			name="custom_tscn"
			custom_minimum_size.x=200
		datatype.COST:
			name="cost"
		datatype.MELEE_ATK:
			name="melee_atk"
			custom_minimum_size.x=70
		datatype.RANGED_ATK:
			name="ranged_atk"
			custom_minimum_size.x=70
		datatype.HEALTH:
			name="health"
		datatype.RACE:
			name="race"
		_:
			name="unknown"
	if val:
		if val is int:
			text=String.num_int64(val)
		elif val is String:
			text=val
	else:
		text="0"

func get_data()->Variant:
	if !text:
		text="0"
	match data_type:
		datatype.ID:
			return text.to_int()
		datatype.NAME:
			return text
		datatype.CUSTOM_TSCN:
			return text
		datatype.COST:
			return text.to_int()
		datatype.MELEE_ATK:
			return text.to_int()
		datatype.RANGED_ATK:
			return text.to_int()
		datatype.HEALTH:
			return text.to_int()
		datatype.RACE:
			return text
		_:
			return null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
