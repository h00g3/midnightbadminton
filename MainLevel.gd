extends Node2D

onready var fanny = $PlayerF
onready var kenny = $PlayerK

onready var fannyscore = 0
onready var kennyscore = 0

func _physics_process(delta):
	if Input.is_action_pressed("restart") :
		get_tree().reload_current_scene()

# Abschlag funktioniert noch nicht
func abschlag(player):
	var shuttle = preload("res://Shuttle.tscn").instance()
	
	shuttle.sleeping = true
	
	if player == fanny:
		shuttle.position = fanny.position + Vector2(50,-50)
		print ("asdasd")
	if player == kenny:
		shuttle.position = fanny.position + Vector2(-50,-50)
	else:
		return
	
func kennypoint():
	if kennyscore <= 9:
		kennyscore+=1
		abschlag(fanny)
	else:
		win(kenny)

func fannypoint():
	if fannyscore <= 9:
		fannyscore+=1
		abschlag(kenny)
	else:
		win(fanny)

func win(player):
	print (" Wins")
	get_tree().reload_current_scene()
	
func show_scores():
	$Scoreboard/Fscore.text = str(fannyscore)
	$Scoreboard/Kscore.text = str(kennyscore)

func _process(delta):
	show_scores()

func _on_Rechts_body_entered(body):
	if body.get_name() == "Shuttle":
		fannypoint()

func _on_Links_body_entered(body):
	if body.get_name() == "Shuttle":
		kennypoint()
