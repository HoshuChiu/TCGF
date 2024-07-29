extends Object
class_name CardLoader

static var _initialized = false
const verbosity_level : int = SQLite.VERBOSE
var db_name := "res://CardPack/demo.db"
static var CardPackDB:SQLite

static func init():
	var dir=DirAccess.open("res://CardPack")
	if dir:
		CardPackDB=SQLite.new()
		CardPackDB.path="res://CardPack/index.sqlite"
		CardPackDB.verbosity_level=SQLite.VERBOSE
		CardPackDB.open_db()

static func load_card(pack:String,id:int)->BasicCard:
	var selected_rows : Array[Dictionary]
	selected_rows = CardPackDB.select_rows("Classic", "id='"+String.num_int64(id)+"'",
		["id","name","type","custom_tscn","cost","melee_atk","ranged_atk","health","rarity","race","class"]
	)
	
	var card_data=selected_rows[0]
	if card_data["custom_tscn"]:
		return load("res://CardPack/"+pack+"/"+selected_rows[0]["custom_tscn"]+".tscn").instantiate()
	else:
		var card=BasicCard.new()
		card.id=card_data["id"]
		card.card_name=card_data["name"]
		card.type=card_data["type"]
		card.cost=card_data["cost"]
		card.melee_atk=card_data["melee_atk"]
		card.ranged_atk=card_data["ranged_atk"]
		card.health=card_data["health"]
		card.rarity=card_data["rarity"]
		card.race=card_data["race"]
		card.job=card_data["class"]
		return card
	
static func clean():
	CardPackDB.close_db()
	pass
