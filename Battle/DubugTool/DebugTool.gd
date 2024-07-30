extends TabContainer

func toggle_visibility():
	if self.visible==true:
		self.visible=false
		$"../OpenDebugTool".text="打开调试工具"
	else:
		self.visible=true
		$"../OpenDebugTool".text="关闭调试工具"
	
func _ready():
	self.visible=false

func draw_test():
	var pack:String=$"对局/PackSelector".text
	var id:String=$对局/TextEdit2.text
	$"../Superdomain".draw(pack,id.to_int())
