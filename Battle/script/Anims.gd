extends Object
class_name Anims

static func draw(target,tween_p:Tween,dst_pos:Vector3,dst_rot:Vector3):
	tween_p.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween_p.tween_property(target,"position",Vector3(GraphicCtrl.INFOCARD_DRAW_X_OFFSET,
													GraphicCtrl.INFOCARD_DRAW_Y_OFFSET,
													GraphicCtrl.INFOCARD_HEIGHT),0.5)
	tween_p.parallel().tween_property(target,"position:z",6,0.2)
	tween_p.parallel().tween_property(target,"rotation",Vector3(0,0,0),0.4)
	tween_p.set_ease(Tween.EASE_OUT)
	tween_p.tween_property(target,"position",dst_pos,1)
	tween_p.parallel().tween_property(target,"rotation",dst_rot,1) 
