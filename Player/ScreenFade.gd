extends Node

func fade_out():
	print("fade out")
	$AnimationPlayer.play("fade_out")
	
func fade_in():
	$AnimationPlayer.play("fade_in")
