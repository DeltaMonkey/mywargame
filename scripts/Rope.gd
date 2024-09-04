class_name Rope extends Node2D

enum MOVEMENT_STATUS {DOWN, WAIT, UP}

const SPEED: int = 30
const ROLLBACK_SPEED: int = 60

@export var destination_point_y: int = 0
@export var rollback_and_destroy_point_y: int = 0

const ENEMY = preload("res://scenes/Enemy.tscn")

signal OnTheRopeReleased;

var TheRopeReleased: bool = false;
var MoveStatus = MOVEMENT_STATUS.DOWN

var enemy: BaseEnemy

func _ready():
	var enemy_instance = ENEMY.instantiate()
	
	enemy = enemy_instance as BaseEnemy;
	enemy.position = global_position
	
	get_tree().get_root().get_node("Game").add_child.call_deferred(enemy)
	
	enemy.StopEnemyMovementProcess_Force()
	enemy.SlideWithRope(destination_point_y, OnTheRopeReleased)
		
func _process(delta):
	if(MoveStatus == MOVEMENT_STATUS.DOWN):
		if position.y < destination_point_y:
			var velocity = Vector2.ZERO # The rope's movement vector.
			velocity.y += 1
			if velocity.length() > 0:
				velocity = velocity.normalized() * SPEED
			
			position += velocity * delta
		elif position.y >= destination_point_y and !TheRopeReleased:
			TheRopeReleased = true
			OnTheRopeReleased.emit(self)
	elif(MoveStatus == MOVEMENT_STATUS.WAIT):
		pass
	else:
		if position.y > rollback_and_destroy_point_y:
			var velocity = Vector2.ZERO # The rope's movement vector.
			velocity.y -= 1
			if velocity.length() > 0:
				velocity = velocity.normalized() * ROLLBACK_SPEED
			
			position += velocity * delta
		elif position.y <= rollback_and_destroy_point_y:
			queue_free()
