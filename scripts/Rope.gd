extends Node2D

const SPEED: int = 30
@export var destination_point_y: int = 0

var TheRopeReleased: bool = false;
signal OnTheRopeReleased;

func _ready():
	pass # Replace with function body.

func _process(delta):
	if position.y < destination_point_y:
		var velocity = Vector2.ZERO # The rope's movement vector.
		velocity.y += 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
		
		position += velocity * delta
	elif position.y >= destination_point_y and !TheRopeReleased:
		TheRopeReleased = true
		OnTheRopeReleased.emit()
