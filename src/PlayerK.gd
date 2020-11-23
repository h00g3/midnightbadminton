extends KinematicBody2D

export (int) var speed = 200

const ACCELERATION : int = 30

var vel = Vector2()
var jumpForce : int = 400
var gravity : int = 1000

onready var dashing = true

func _physics_process(delta):
	vel.x = 0
	_Steuerung(delta)

func _Steuerung(delta):	
	
	# movement inputs
	if Input.is_action_pressed("ui_right"):
		vel.x = max(vel.x+speed, ACCELERATION)
	if Input.is_action_pressed("ui_left"):
		vel.x = min(vel.x-speed, -ACCELERATION)
	# jump input
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		vel.y -= jumpForce
	
	if Input.is_action_just_pressed("ui_right") and dashing :
		vel.x += jumpForce
		dashing = false
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	#gravity
	vel.y += gravity * delta

func Cheer():
	pass

func Sad():
	pass
