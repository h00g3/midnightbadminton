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
onready var shuttle = load("res://scenes/Shuttle.tscn")

onready var state_machine = $Node2D/AnimationTree.get("parameters/playback")

func _physics_process(delta):
	vel.x = 0
	_Steuerung(delta)

func _Steuerung(delta):	
	
	# movement inputs
	if Input.is_action_pressed("2_right"):
		vel.x = max(vel.x+speed, ACCELERATION)
		Walk()
	if Input.is_action_pressed("2_left"):
		vel.x = min(vel.x-speed, -ACCELERATION)
		Walk()

	# jump input
	if Input.is_action_just_pressed("2_up") and is_on_floor():
		vel.y -= jumpForce
		Jump()
		doublejump_zaehler = true
	if Input.is_action_just_pressed("2_up") and is_on_floor() == false :
		if doublejump_zaehler == true :
			vel.y -= jumpForce
			Jump()
			doublejump_zaehler = false
	# applying the velocity
	vel = move_and_slide(vel, Vector2.UP)
	#gravity
	vel.y += gravity * delta

func Jump():
	state_machine.travel("Jump")
#	var anim_jump = get_node("Node2D/AnimationPlayer").get_animation("Jump")
#	anim_jump.set_loop(false)
#	$Node2D/AnimationPlayer.play("Jump")

func Walk():
	if state_machine.get_current_node() != ("WalkR"):
		state_machine.travel("WalkR")
#	var anim_jump = get_node("Node2D/AnimationPlayer").get_animation("WalkR")
#	anim_jump.set_loop(false)
#	$Node2D/AnimationPlayer.play("WalkR")
	
func Schlag():
	state_machine.travel("Schlag")
#	var anim_jump = get_node("Node2D/AnimationPlayer").get_animation("Schlag")
#	anim_jump.set_loop(false)
#	$Node2D/AnimationPlayer.play("Schlag")

func Cheer():
	var anim_jump = get_node("Node2D/AnimationPlayer").get_animation("Winning")
	anim_jump.set_loop(false)
	$Node2D/AnimationPlayer.play("Winning")

func Sad():
	var anim_jump = get_node("Node2D/AnimationPlayer").get_animation("Lose")
	anim_jump.set_loop(false)
	$Node2D/AnimationPlayer.play("Lose")


func _on_Area2D_body_entered(body):
	Schlag()
