extends Node2D

#onready var playerLeft = load("res://src/Player.gd").new("Fanny", $PlayerF)
#onready var playerRight = load("res://src/Player.gd").new("Kenny", $PlayerK)
onready var players = {}
#var collisionShapeLeft
#var collisionShapeRight
onready var shuttle = $Shuttle

onready var serviceOffset = Vector2(0,-200)

#onready var playerLeftscore = 0
#onready var playerRightscore = 0
onready var winscore = 10

func _ready():
	players[Player.Side.LEFT] = load("res://src/Player.gd").new("Fanny", $PlayerF, Player.Side.LEFT)
	players[Player.Side.RIGHT] = load("res://src/Player.gd").new("Kenny", $PlayerK, Player.Side.RIGHT)
#	collisionShapeLeft = getPlayerCollisionShape(playerLeft.physics_body)
#	collisionShapeRight = getPlayerCollisionShape(playerRight.physics_body)

func _physics_process(delta):
	if Input.is_action_pressed("restart") :
		get_tree().reload_current_scene()

func _on_Rechts_body_entered(body):
	if isShuttle(body):
#		playerLeftpoint()
		score(Player.Side.LEFT)

func _on_Links_body_entered(body):
	if isShuttle(body):
#		playerRightpoint()
		score(Player.Side.RIGHT)

func score(side):
	var player = players[side]
	var score = player.score()
	if score < winscore:
		var other_side = player.other_side()
		var other_player = players[other_side]
		abschlag(other_player)
	else:
		win(side)

# Abschlag funktioniert noch nicht
func abschlag(player):
	#shuttle = preload("res://Shuttle.tscn").instance()
	#shuttle.sleeping = true
	
	var collisionShape = getPlayerCollisionShape(player.physics_body)
	service(collisionShape)
#	if player == playerLeft:
#		service(collisionShapeRight)
#	elif player == playerRight:
#		service(collisionShapeLeft)
#	else:
#		return
	
func service(player):
	var position = player.position + serviceOffset
	shuttle.hitGround(position)

#func playerRightpoint():
#	playerRightscore+=1
#	if playerRightscore < winscore:
#		abschlag(playerLeft)
#	else:
#		win(playerRight)
#
#func playerLeftpoint():
#	playerLeftscore+=1
#	if playerLeftscore < winscore:
#		abschlag(playerRight)
#	else:
#		win(playerLeft)

func win(player):
	print (" Wins")
	get_tree().reload_current_scene()
	
func show_scores():
	$Scoreboard/Fscore.text = str(players[Player.Side.LEFT].score)
	$Scoreboard/Kscore.text = str(players[Player.Side.RIGHT].score)
#	$Scoreboard/Fscore.text = str(playerLeftscore)
#	$Scoreboard/Kscore.text = str(playerRightscore)

func _process(delta):
	show_scores()



func isShuttle(body):
	return body.get_name() == "Shuttle"

func getPlayerCollisionShape(player):
	for child in player.get_children():
		if child is CollisionShape2D:
			return child
	push_error ( "no collision shape found for player " % player)
