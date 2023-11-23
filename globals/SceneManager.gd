extends Node

@export var og_player : Player
var player : Player
var current_scene

var current_transition_origin : Doorway
var current_player : Player
var is_switching_scenes = false
var fader : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)
	get_tree().current_scene.add_child(og_player)
	player = og_player
	player.position = current_scene.init_player_position
	set_camera()
	fader = player.get_node("CanvasLayer").get_node("ScreenFade")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func fade_out():
	fader.fade_out()
	player.FSM.force_walk_for_time(0.33)

func on_doorway_entered(origin : Doorway, player : Player):
	current_transition_origin = origin
	current_player = player
	$AnimationPlayer.play("doorway_transition")

func d_on_doorway_entered():
	call_deferred("switch_scene_via_doorway")
	
func switch_scene_via_doorway():
	is_switching_scenes = true
	player.FSM.force_walk_for_time(0)
	current_player.get_parent().remove_child(current_player)
	var s = load(current_transition_origin.dest_scene_path)
	var dest_doorway_name = current_transition_origin.dest_door_name
	current_scene.free()
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	var dest_doorway_path = "doorways/" + dest_doorway_name
	var dest_doorway = current_scene.get_node(dest_doorway_path)
	player.position = dest_doorway.position
	player.can_enter_doors = false
	set_camera()
	get_tree().current_scene.add_child(player)
	await(get_tree().create_timer(0.5).timeout)
	fade_in()
	is_switching_scenes = false
	
func fade_in():
	player.FSM.force_walk_for_time(0.33)
	fader.fade_in()

func set_camera():
	print("trying to set camera")
	print(current_scene.get_node("_CAMERA").name)
	Cam.zones = current_scene.get_node("_CAMERA")
