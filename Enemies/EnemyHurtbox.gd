extends CharacterBody2D

@onready var HealthManager : HealthManager = $HealthManager
@onready var driver : EnemyFSMDriver = $EnemyFSMDriver
@onready var WhiteoutTimer : Timer = $Sprite2D/WhiteoutTimer
@onready var Sprite : Sprite2D = $Sprite2D

var current_whiteout : float = 0

func recieve_hit(damage, knockback, player_is_facing_right):
	HealthManager.take_damage(damage)
	driver.apply_new_knockback(player_is_facing_right, knockback)
	(Sprite.material as ShaderMaterial).set_shader_parameter("fill", Color(.8,.8,.8,1))
	current_whiteout = 1
	
func _process(delta):
	current_whiteout = lerp(current_whiteout, 0.0, delta * 20)
	(Sprite.material as ShaderMaterial).set_shader_parameter("fill", Color(.8,.8,.8, current_whiteout))
