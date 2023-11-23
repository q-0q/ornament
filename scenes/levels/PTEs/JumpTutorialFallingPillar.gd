extends PersistentTilemapEvent

var end_pos : Vector2 = Vector2(-3, 50)
var end_rot : float = 8
var start_pos : Vector2
var start_rot : float

var executing : bool = false
var elapsed : float = 0

@export var time_to_play_particles : float
@export var curve : Curve
@export var animation_time : float

func _process(delta):
	if !executing: return
	var i : float = elapsed / animation_time
	var c : float = curve.sample(i)
	var new_pos : Vector2 = start_pos.lerp(end_pos, c)
	var new_rot : float = lerp(start_rot, end_rot, c)
	tilemap.rotation_degrees = new_rot
	tilemap.position = new_pos
	Util.player_fsm.Player.velocity.x = 8
	elapsed += delta
	if c > 0.98: tilemap.get_node("particles").emitting = true
	if elapsed > animation_time: executing = false

func execute():
	elapsed = 0
	executing = true
	start_pos = tilemap.position
	start_rot = tilemap.rotation_degrees
	Util.player_fsm.set_input_lock(animation_time)
	
func set_to_executed_state():
	tilemap.position = end_pos
	tilemap.rotation_degrees = end_rot

func _on_body_entered(body):
	PteManager.try_execute(self)
