extends Label

const START_SECONDS = 500

var ms = 0
var s = START_SECONDS
var m = 0

signal TIMEOVER

func _process(delta):
	if ms < 1 :
		s-=1
		ms = 9

	if s < 14 :
		set_Timer_color(Color(0.78,0,0,1))
	elif s < 34 :
		set_Timer_color(Color(1,1,0,1))
	elif s > 34 :
		set_Timer_color(Color(0.5,1,0,1))
	
	if s <= 0 :
		emit_signal("TIMEOVER")
		reset_Timer()
	
	set_text(str(s)+":"+str(ms))

func reset_Timer():
	s = START_SECONDS
	ms = 0

func set_Timer_color(rgba):
	self.add_color_override("font_color", rgba)

func _on_Timer_timeout():
	if s > 0 :
		ms -= 1
