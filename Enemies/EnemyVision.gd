extends Area2D

@onready var cast : RayCast2D = $RayCast2D
@onready var enemy = $"../.."

func can_see_player():
	if !has_overlapping_bodies(): return
	if $"..".scale.x < 0: cast.scale.x = -1
	else: cast.scale.x = 1
	cast.target_position = Util.player_position - enemy.global_position
	if !cast.is_colliding(): return
	return cast.get_collider().name == "Player"
