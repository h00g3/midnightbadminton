extends Node2D

onready var playerLeft = $PlayerF
onready var playerRight = $PlayerK
var collisionShapeLeft
var collisionShapeRight
onready var shuttle = $Shuttle

onready var serviceOffset = Vector2(0,-100)

onready var playerLeftscore = 0
onready var playerRightscore = 0
onready var winscore = 9

func _ready():
	collisionShapeLeft = getPlayerCollisionShape(playerLeft)
	collisionShapeRight = getPlayerCollisionShape(playerRight)

func _physics_process(delta):
	if Input.is_action_pressed("restart") :
		get_tree().reload_current_scene()

# Abschlag funktioniert noch nicht
func abschlag(player):
	#shuttle = preload("res://Shuttle.tscn").instance()
	#shuttle.sleeping = true
	
	
	var shuttleTransform = shuttle.get_transform()
	
#	print("playerLeft: %d, %d" % [playerLeft.position.x, playerLeft.position.y])
#	print("playerRight: %d, %d" % [playerRight.position.x, playerRight.position.y])
#	print("shuttle before score: %d, %d" % [shuttle.position.x, shuttle.position.y])
	
#	print("playerLeft: %s" % playerLeft.get_child_count())
#	print("playerRight: %s" % playerRight.get_child_count())
	debugPlayer("left", playerLeft)
	debugPlayer("right", playerRight)
	print("shuttle before score: %s" % shuttleTransform)
	
	if player == playerLeft:
		service(collisionShapeRight)
	elif player == playerRight:
		service(collisionShapeLeft)
	else:
		return
	
	print("shuttle after score: %s" % shuttleTransform)

func service(player):
	var shuttleBodyId = shuttle.get_rid()
	#PhysicServer.body_get_direct_state (shuttleBodyId)
	#shuttle.integrate_forces(state)
	shuttle.set_sleeping(true)
	shuttle.set_global_position(player.position + serviceOffset)
#	shuttle.sleeping = true

func playerRightpoint():
	playerRightscore+=1
	if playerRightscore < winscore:
		abschlag(playerLeft)
	else:
		win(playerRight)

func playerLeftpoint():
	playerLeftscore+=1
	if playerLeftscore < winscore:
		abschlag(playerRight)
	else:
		win(playerLeft)

#func score(playerscore):
#	playerscore++
#	if(playerscore)

func win(player):
	print (" Wins")
	get_tree().reload_current_scene()
	
func show_scores():
	$Scoreboard/Fscore.text = str(playerLeftscore)
	$Scoreboard/Kscore.text = str(playerRightscore)

func _process(delta):
	show_scores()

func _on_Rechts_body_entered(body):
	if isShuttle(body):
		playerLeftpoint()

func _on_Links_body_entered(body):
	if isShuttle(body):
		playerRightpoint()

func isShuttle(body):
	return body.get_name() == "Shuttle"

func debugPlayer(side, player):
	for child in player.get_children():
		if child is CollisionShape2D:
			print((child as CollisionShape2D).transform)
#	print("%s: %s" % [side, player.get_child_count()])

func getPlayerCollisionShape(player):
	for child in player.get_children():
		if child is CollisionShape2D:
			return child
	push_error ( "no collision shape found for player " % player)
