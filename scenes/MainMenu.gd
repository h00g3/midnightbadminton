extends Control
func _ready():
	$Glow/Tween.start()
func _process(delta):
	$Glow/Tween.interpolate_property($Glow, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	#$Glow.modulate(Color(1,1,1,0))
