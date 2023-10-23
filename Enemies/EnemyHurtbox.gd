extends Area2D

@onready var HealthManager : HealthManager = $"../HealthManager"
@onready var ForceManager : ForceManager = $"../ForceManager"
@onready var WhiteoutTimer : Timer = $"../Sprite2D/WhiteoutTimer"
@onready var Sprite : Sprite2D = $"../Sprite2D"
@onready var aq : AnimationQueue = $"../AnimationQueue"
@onready var driver : EnemyFSMDriver = $"../EnemyFSMDriver"

var current_whiteout : float = 0

func recieve_hit(damage, knockback):
	HealthManager.take_damage(damage)
	ForceManager.apply_new_force(knockback)
	(Sprite.material as ShaderMaterial).set_shader_parameter("fill", Color(.8,.8,.8,1))
	current_whiteout = 1
	HitstunManager.DO_HITSTUN.emit(0.09, get_tree())	
	aq.play("idle")
	aq.play("rat_hit")
	driver._set_face_dir(Util.player_fsm.is_facing_right)
	
func _process(delta):
	current_whiteout = lerp(current_whiteout, 0.0, delta * 20)
	(Sprite.material as ShaderMaterial).set_shader_parameter("fill", Color(.8,.8,.8, current_whiteout))
