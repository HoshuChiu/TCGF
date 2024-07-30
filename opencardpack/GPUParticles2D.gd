extends GPUParticles2D

@onready var timeCreated = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() - timeCreated > 1000:
		queue_free()
		
	

