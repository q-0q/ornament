extends Node

class_name AnimationQueue

@onready var animate : AnimationPlayer = $"../AnimationPlayer"

var lockout_time : float = 0
var time_in_current_animation : float = 0

var queued_animation_name : String = ""
var queued_lockout_time : float = 0

func force(name: String, new_lockout_time : float = 0):
	time_in_current_animation = 0
	lockout_time = new_lockout_time
	animate.play(name)
	
func play(name: String, new_lockout_time : float = 0):
	if (time_in_current_animation < lockout_time):
		queued_animation_name = name
		queued_lockout_time = new_lockout_time
		return
	else:
		force(name, new_lockout_time)
		return

func clear_queue():
	queued_animation_name = ""
	queued_lockout_time = 0

func _process(delta):
	time_in_current_animation += delta
	if (time_in_current_animation >= lockout_time and
		queued_animation_name != ""):
			force(queued_animation_name, queued_lockout_time)
			clear_queue()
