extends Area2D

@onready var FSM : FSM = $"../../FSM"
@onready var particles : GPUParticles2D = $GPUParticles2D


func _on_area_entered(area):
	if !area.is_in_group("hurtbox"): return
	
	area.recieve_hit(2, FSM.current_enemy_knockback())
	FSM.apply_new_knockback()
	#particles.emitting = true

func _process(delta):
	pass
	#if particles.emitting: particles.emitting = false
	
