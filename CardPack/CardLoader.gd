extends Object
class_name CardLoader

class CardResource extends Object:
	var type:BasicCard.CardType
	var img_path:String
	var script_path:String

static func load(pack:String,id:int)->CardResource:
	return CardResource.new()
	
