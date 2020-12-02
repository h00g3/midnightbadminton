extends Node2D

var duration = 0

func _process(delta):
	if Input.is_action_pressed("2_down"):
		duration += delta

	if Input.is_action_just_released("2_down"):
		duration = 0
	
	if duration >= 3 :
		$AnimationPlayer.play("ProgressShake")
	else:
		$AnimationPlayer.stop()
		
	$TextureProgress.value = duration
	print (duration)
