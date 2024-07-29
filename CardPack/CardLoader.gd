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

static func load(pack:String,id:int)->BasicCard:
	var selected_rows : Array[Dictionary] = CardPackDB.select_rows("Classic", "id='"+String.num_int64(id)+"'", ["name", "cost"])
	for x in selected_rows:
		print(x["name"])
	return BasicCard.new()
	
static func clean():
	pass
