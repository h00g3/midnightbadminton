# Player-Script Fanny (fast identisch mit Kennny)
extends PlayerBody

# Variable zum Einstellen in der Godot UI für die Gecchwindigkeit
export (int) var speed = 200 

# Beschleunigung des Spielers
const ACCELERATION : int = 30

var jumpForce : int = 400
const gravity : int = 1000

# Doppelsprung-Kontrollvariable, Abschlag
onready var doublejump_zaehler : bool = false

#onready var racket = load("res://src/Racket.gd").new(Player.Side.LEFT)

func _physics_process(delta):
	vel.x = 0
	_Steuerung(delta)

func _Steuerung(delta):	
	
	# movement inputs
	if Input.is_action_pressed("2_right"):
		vel.x = max(vel.x+speed, ACCELERATION)
		if is_on_floor():
			Walk()
	elif Input.is_action_pressed("2_left") :
		vel.x = min(vel.x-speed, -ACCELERATION)
		if is_on_floor():
			Walk()
	else:
		if is_on_floor() and state_machine.get_current_node() == ("Walking"):
			state_machine.travel("Idle")

	if Input.is_action_just_pressed("2_up"):
		if is_on_floor():
			vel.y -= jumpForce
			Jump()
			doublejump_zaehler = true
		elif doublejump_zaehler == true :
			vel.y -= jumpForce
			Jump()
			doublejump_zaehler = false
	#gravity
	vel.y += gravity * delta
	vel = move_and_slide(vel, Vector2.UP)
