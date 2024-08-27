extends Node2D

const SPEED: int = 30
@export var destination_point_y: int = 0

const ENEMY = preload("res://scenes/Enemy.tscn")

signal OnTheRopeReleased;

var TheRopeReleased: bool = false;
var enemy: BaseEnemy

func _ready():
	var enemy_instance = ENEMY.instantiate()
	
	enemy = enemy_instance as BaseEnemy;
	enemy.position = global_position
	
	get_tree().get_root().get_node("Game").add_child.call_deferred(enemy)
	
	enemy.StopEnemyMovementProcess_Force()
	enemy.SlideWithRope(OnTheRopeReleased)
		
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
