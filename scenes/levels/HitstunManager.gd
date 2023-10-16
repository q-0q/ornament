extends Node

@onready var timer : Timer = $Timer
var room : SceneTree

signal DO_HITSTUN(length, tree)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(end_hitstun)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_hitstun(length, tree):
	print("start hitstun")
	timer.start(length)
	room = tree
	room.paused = true

func end_hitstun():
	print("end hitstun")
	room.paused = false

func _on_timer_timeout():
	end_hitstun()

func _on_do_hitstun(length, tree):
	start_hitstun(length, tree)
