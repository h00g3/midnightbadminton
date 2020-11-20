# Player-Script Fanny (fast identisch mit Kennny)

extends KinematicBody2D

# Variable zum Einstellen in der Godot UI für die Gecchwindigkeit
export (int) var speed = 200 

# Beschleunigung des Spielers
const ACCELERATION : int = 30

# Vektor für Bewegung, Sprungkraft und Gravity
var vel = Vector2()
var jumpForce : int = 400
var gravity : int = 1000

# Doppelsprung-Kontrollvariable, Abschlag
onready var doublejump_zaehler : bool = false
onready var abschlag_fanny : bool = true
onready var shuttle = get_parent().get_node("Shuttle")


func _physics_process(delta):
	vel.x = 0
	_Steuerung(delta)

func free_shuttle():
	shuttle.sleeping = false

func _Steuerung(delta):	
	
	# movement inputs
	if Input.is_action_pressed("2_right"):
		vel.x = max(vel.x+speed, ACCELERATION)
	if Input.is_action_pressed("2_left"):
		vel.x = min(vel.x-speed, -ACCELERATION)
	# jump input
	if Input.is_action_just_pressed("2_up") and is_on_floor():
		vel.y -= jumpForce
		doublejump_zaehler = true
		if abschlag_fanny == true:
			free_shuttle()
	if Input.is_action_just_pressed("2_up") and is_on_floor() == false :
		if doublejump_zaehler == true :
			vel.y -= jumpForce
			doublejump_zaehler = false
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	#gravity
	vel.y += gravity * delta

