extends Control

func _ready():
	$Glow/AnimationPlayer.play("flicker")




func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/MainLevel.tscn")


func _on_TextureButton3_pressed():
	get_tree().quit()
