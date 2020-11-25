extends KinematicBody2D

class_name PlayerBody

onready var racket = load("res://src/Racket.gd").new(Player.Side.LEFT)

onready var state_machine = $Node2D/AnimationTree.get("parameters/playback")



func Jump():
	state_machine.travel("Jump")

func Walk():
	if state_machine.get_current_node() != ("WalkR"):
		state_machine.travel("WalkR")

func Schlag():
	state_machine.travel("Schlag")

func Cheer():
	state_machine.travel("Winning")

func Sad():
	state_machine.travel("Lose")

func _on_Area2D_body_entered(body):
	print("area entered")
	Schlag()
	racket.hit_shuttle(body)
