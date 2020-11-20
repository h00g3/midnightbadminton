extends RigidBody2D

export (int) var max_speed = 200
var motion = Vector2()

func _physics_process(delta):
	
	
	
	var movecurve = get_linear_velocity().normalized()
	self.rotation = movecurve.angle()
	
	$Schlagpartikel.direction = -movecurve

func _on_Shuttle_body_entered(body):
	var shuttle_speed = get_linear_velocity().length()
	$Schlagpartikel.amount = shuttle_speed/10
	$Schlagpartikel.initial_velocity = shuttle_speed
	$Schlagpartikel.emitting = true
	print (shuttle_speed)
		

