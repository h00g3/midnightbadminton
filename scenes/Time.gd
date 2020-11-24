extends Label

var ms = 11
var s = 111
var m = 0

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
	
	set_text(str(s)+":"+str(ms))
pass

func set_Timer_color(rgba):
	self.add_color_override("font_color", rgba)

func _on_Timer_timeout():
	if s > 0 :
		ms -= 1
pass
