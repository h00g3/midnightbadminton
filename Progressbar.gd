extends Node2D

var duration = 0

export (String) var key_down

func _process(delta):
	if Input.is_action_pressed(key_down):
		duration += delta

	if Input.is_action_just_released(key_down):
		duration = 0
	
	if duration >= 2 :
		$AnimationPlayer.play("ProgressShake")
	else:
		$AnimationPlayer.stop()
		
	$TextureProgress.value = duration

func get_value():
	return $TextureProgress.value
