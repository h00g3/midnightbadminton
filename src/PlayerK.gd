extends PlayerBody

export (int) var speed = 200

const ACCELERATION : int = 30

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
	vel.y += gravity * delta
	vel = move_and_slide(vel, Vector2.UP)
	#gravity
