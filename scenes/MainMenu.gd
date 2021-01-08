# Steuerung des Hauptmenüs

extends Control

var credit_checker = false 

func _ready():
	$Glow/AnimationPlayer.play("flicker")

func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/MainLevel.tscn")

func _on_TextureButton3_pressed():
	get_tree().quit()


func _on_TextureButton4_pressed():
	$CREDITS.visible = true 
	credit_checker = true

func _on_MainMenu_gui_input(event):
	if event is InputEventMouseButton:
		if credit_checker == true :
			$CREDITS.visible = false
			credit_checker = false
