extends KinematicBody2D

export (int) var speed = 200

const ACCELERATION : int = 30

var vel = Vector2()
var jumpForce : int = 400
var gravity : int = 1000

onready var dashing = true

onready var state_machine = $Node2D/AnimationTree.get("parameters/playback")

func _physics_process(delta):
	vel.x = 0
	_Steuerung(delta)

func _Steuerung(delta):	
	
	# movement inputs
	if Input.is_action_pressed("ui_right"):
		vel.x = max(vel.x+speed, ACCELERATION)
		Walk()
	elif Input.is_action_pressed("ui_left"):
		vel.x = min(vel.x-speed, -ACCELERATION)
		Walk()
	else:
		if is_on_floor() and state_machine.get_current_node()== ("Walking"):
			state_machine.travel("Idle")
	# jump input
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		vel.y -= jumpForce
		Jump()
	
	if Input.is_action_just_pressed("ui_right") and dashing :
		vel.x += jumpForce
		dashing = false
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	#gravity
	vel.y += gravity * delta

func Jump():
	state_machine.travel("Jump")

func Walk():
	if state_machine.get_current_node() != ("Walking"):
		state_machine.travel("Walking")

func Schlag():
	state_machine.travel("Schlag")

func Cheer():
	state_machine.travel("Winning")

func Sad():
	state_machine.travel("Lose")


func _on_Area2D_body_entered(body):
	Schlag()
