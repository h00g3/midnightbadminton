extends RigidBody2D

export (int) var max_speed = 200

func _physics_process(delta):
	
	var movecurve = get_linear_velocity().normalized()
	self.rotation = movecurve.angle()
#	$Schlagpartikel.direction = -movecurve
#	var shuttle_speed = get_linear_velocity().length()
#	$Schlagpartikel.amount = shuttle_speed/10
#	$Schlagpartikel.initial_velocity = shuttle_speed
#	$Schlagpartikel.emitting = true


#func printForces():
#	print("linear velocity: %s" % linear_velocity)
#	print("inertia: %s" % inertia)
#	print("bounce: %s" % bounce)
#	print("torque: %s" % applied_torque)
#	print("gravity scale: %s " % gravity_scale)
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
