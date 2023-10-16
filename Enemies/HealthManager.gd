extends Node

class_name HealthManager

@export var max_health : int
@onready var current_health = max_health
@onready var Enemy = $".."

func take_damage (damage):
	current_health -= damage
	if current_health <= 0:
		Enemy.queue_free()
