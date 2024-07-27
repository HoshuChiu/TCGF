extends Object
class_name CardLoader

static var _initialized = false
const verbosity_level : int = SQLite.VERBOSE
var db_name := "res://CardPack/demo.db"
static var CardPackDB:Dictionary

static func init():
	var dir=DirAccess.open("res://CardPack")
	if dir:
		var dirs=dir.get_directories()
		
		for packdir:String in dirs:
			var db=SQLite.new()
			db.path="res://CardPack/"+packdir+"/index.db"
			db.verbosity_level=SQLite.VERBOSE
			db.open_db()

	pass

static func load(pack:String,id:int)->BasicCard:
	
	return BasicCard.new()
	
static func clean():
	for packdb in CardPackDB:
		#packdb.close_db()
		pass
