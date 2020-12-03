extends RigidBody2D

export (int) var max_speed = 200

onready var shuttle_audio = $AudioStreamPlayer2D
var random = 0

func _physics_process(delta):
	
	var movecurve = get_linear_velocity().normalized()
	self.rotation = movecurve.angle()
#	

func emit_schlag_particles(movecurve) :
	$Schlagpartikel.direction = -movecurve
	var shuttle_speed = get_linear_velocity().length()
	$Schlagpartikel.amount = shuttle_speed/10
	#$Schlagpartikel.initial_velocity = shuttle_speed
	$Schlagpartikel.emitting = true

#func printForces():
#	print("linear velocity: %s" % linear_velocity)
#	print("inertia: %s" % inertia)
#	print("bounce: %s" % bounce)
#	print("torque: %s" % applied_torque)
#	print("gravity scale: %s " % gravity_scale)

func make_random_nr(von, bis) :
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random = rng.randi_range(von, bis)
	return random

func _on_Shuttle_body_entered(body):
	
	emit_schlag_particles(get_linear_velocity().normalized())
	
	if body.get_name() == ("Boden") or ("Netz") :
		shuttle_audio.play(make_random_nr(6, 10))
		yield(get_tree().create_timer(0.5), "timeout")
		shuttle_audio.stop()
