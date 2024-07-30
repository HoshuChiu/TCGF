@tool
extends Control

@onready var behind: TextureRect = $card_behind
@onready var front: TextureRect = $card_front
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audiostreamplayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var Gpuparticle: GPUParticles2D = $GPUParticles2D

@export_range(0.0,180.0) var y_rot = 0.0:
	set(value):
		y_rot = value
		if front:#设定翻转角度
			front.material.set("shader_parameter/y_rot",(180.0-value)*-1)
		if behind:
			behind.material.set("shader_parameter/y_rot",value)

func flipAnim():
	animation_player.play("flip_animation")
	
func voiceplay():
	audiostreamplayer.play()

	
# 按下按钮时按钮放大
func playAnim(target):
	target.pivot_offset = target.size/2
	var tween = create_tween()
	tween.tween_property(target,"scale",Vector2(1.2,1.2),0.1)

# 松开按钮时按钮收缩回原尺寸
func playAnim2(target):
	var tween = create_tween()
	tween.tween_property(target,"scale",Vector2(1.1,1.1),0.1)
	await tween.finished

func _on_texture_button_button_down() -> void:
	playAnim(behind)


func _on_texture_button_pressed() -> void:
	await playAnim2(behind)
	flipAnim()
	voiceplay()

	
