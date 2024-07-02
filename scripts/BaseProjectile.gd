class_name BaseProjectile extends Area2D

var SPEED: int = 200
var direction: int

func _ready():
	direction = 1;

func _process(delta):
	move_local_x(direction * SPEED * delta)
