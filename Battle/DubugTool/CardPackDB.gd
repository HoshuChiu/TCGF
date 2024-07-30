extends VBoxContainer

var current_cardpack:String
var current_cardpack_ind:int
# Called when the node enters the scene tree for the first time.
func _ready():
	var popup:PopupMenu=$MenuButton.get_popup()
	for pack in CardLoader.get_packs():
		popup.add_item(pack)
	popup.id_pressed.connect(on_popup_selected)
	var hb=$CardConstructor1
	hb.add_child(DataEdit.new(DataEdit.datatype.ID))
	hb.add_child(DataEdit.new(DataEdit.datatype.NAME))
	hb.add_child(DataSelector.new(DataSelector.datatype.TYPE))
	hb.add_child(DataEdit.new(DataEdit.datatype.COST))
	hb.add_child(DataEdit.new(DataEdit.datatype.MELEE_ATK))
	hb.add_child(DataEdit.new(DataEdit.datatype.RANGED_ATK))
	hb.add_child(DataEdit.new(DataEdit.datatype.HEALTH))
	hb.add_child(DataSelector.new(DataSelector.datatype.RARITY))
	hb.add_child(DataEdit.new(DataEdit.datatype.RACE))
	hb.add_child(DataSelector.new(DataSelector.datatype.JOB))
	var btn:Button=Button.new()
	btn.text="新建"
	btn.custom_minimum_size.x=80
	btn.connect("pressed",on_newbtn_pressed1)
	hb.add_child(btn)
	hb=$CardConstructor2
	hb.add_child(DataEdit.new(DataEdit.datatype.ID))
	hb.add_child(DataEdit.new(DataEdit.datatype.NAME))
	var lb=Label.new()
	lb.custom_minimum_size.x=90
	lb.text="自定义卡牌:"
	hb.add_child(lb)
	hb.add_child(DataEdit.new(DataEdit.datatype.CUSTOM_TSCN))
	btn=Button.new()
	btn.text="新建"
	btn.custom_minimum_size.x=80
	btn.connect("pressed",on_newbtn_pressed2)
	hb.add_child(btn)
	
	if popup.get_item_count()!=0:
		on_popup_selected(0)
	pass # Replace with function body.

var row_id_ind:Array[int]

func on_popup_selected(index:int):
	for i in $ScrollContainer/Data.get_children():
		for j in i.get_children():
			i.remove_child(j)
			j.queue_free()
		$ScrollContainer/Data.remove_child(i)
		i.queue_free()
	row_id_ind.clear()
	var popup:PopupMenu=$MenuButton.get_popup()
	current_cardpack_ind=index
	current_cardpack=popup.get_item_text(index)
	$MenuButton.text="选中的数据库["+current_cardpack+"]"
	
	var cards=CardLoader.load_pack(current_cardpack)
	var i=0
	for card in cards:
		var hb:HBoxContainer=HBoxContainer.new()
		hb.custom_minimum_size.y=40
		hb.name=String.num_int64(i)
		hb.add_child(DataEdit.new(DataEdit.datatype.ID,card["id"]))
		row_id_ind.append(card["id"])
		hb.add_child(DataEdit.new(DataEdit.datatype.NAME,card["name"]))
		
		if card["custom_tscn"]:
			var label:Label=Label.new()
			label.text="自定义卡牌"
			label.custom_minimum_size.x=90
			hb.add_child(label)
			hb.add_child(DataEdit.new(DataEdit.datatype.CUSTOM_TSCN,card["custom_tscn"]))
		else:
			hb.add_child(DataSelector.new(DataSelector.datatype.TYPE))
			hb.add_child(DataEdit.new(DataEdit.datatype.COST,card["cost"]))
			hb.add_child(DataEdit.new(DataEdit.datatype.MELEE_ATK,card["melee_atk"]))
			hb.add_child(DataEdit.new(DataEdit.datatype.RANGED_ATK,card["ranged_atk"]))
			hb.add_child(DataEdit.new(DataEdit.datatype.HEALTH,card["health"]))
			hb.add_child(DataSelector.new(DataSelector.datatype.RARITY,card["rarity"]))
			hb.add_child(DataEdit.new(DataEdit.datatype.RACE,card["race"]))
			hb.add_child(DataSelector.new(DataSelector.datatype.JOB,card["class"]))
			
		var btn:Button=Button.new()
		btn.text="更新"
		btn.custom_minimum_size.x=40
		btn.connect("pressed",on_updbtn_pressed.bind(i))
		hb.add_child(btn)
			
		btn=Button.new()
		btn.text="删除"
		btn.custom_minimum_size.x=40
		btn.connect("pressed",on_delbtn_pressed.bind(i))
		hb.add_child(btn)
		$ScrollContainer/Data.add_child(hb)
		i+=1
	pass

func on_updbtn_pressed(row:int):
	var hb:HBoxContainer=$ScrollContainer/Data.get_child(row)
	#hb.get_child()
	var data:Dictionary
	var id:int
	for item in hb.get_children():
		if (item is DataEdit)or(item is DataSelector):
			data[item.name]=item.get_data()
		if item.name=="id":
			id=item.get_data()
	var counter=0
	for i in range(0,row_id_ind.size()):
		if row==i:
			continue
		if id==row_id_ind[i]:
			counter+=1
	if counter>0:
		hb.get_child(0).text=String.num_int64(row_id_ind[row])
		print("id不可以重复")
		return
	CardLoader.update_card(current_cardpack,row_id_ind[row],data)
	row_id_ind[row]=id
	pass

func on_delbtn_pressed(row:int):
	CardLoader.delete_card(current_cardpack,row_id_ind[row])
	on_popup_selected(current_cardpack_ind)
	pass

func on_newbtn_pressed1():
	var hb:HBoxContainer=$CardConstructor1
	if CardLoader.get_packs().has(current_cardpack):
		var data:Dictionary
		var id:int
		for item in hb.get_children():
			if (item is DataEdit)or(item is DataSelector):
				data[item.name]=item.get_data()
			if item.name=="id":
				id=item.get_data()
				if row_id_ind.has(id):
					print("id不允许重复")
					return
		CardLoader.new_card(current_cardpack,data)
		on_popup_selected(current_cardpack_ind)
	else:
		print("请选择卡包系列")

func on_newbtn_pressed2():
	var hb:HBoxContainer=$CardConstructor2
	if CardLoader.get_packs().has(current_cardpack):
		var data:Dictionary
		var id:int
		for item in hb.get_children():
			if (item is DataEdit)or(item is DataSelector):
				data[item.name]=item.get_data()
			if item.name=="id":
				id=item.get_data()
				if row_id_ind.has(id):
					print("id不允许重复")
					return
		CardLoader.new_card(current_cardpack,data)
		on_popup_selected(current_cardpack_ind)
	else:
		print("请选择卡包系列")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
