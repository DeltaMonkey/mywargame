class_name Rope extends Node2D

#CONSTS
const SPEED: int = 30
const ROLLBACK_SPEED: int = 60
const ENEMY: PackedScene = preload("res://scenes/Enemy.tscn")

#@ONREADIES
@export var DestinationPointY: float = 0.0
@export var RollbackAndDestroyPointY: float = 0.0
@export var EnemyDefaultGun: PackedScene = null;

#VARS
var Enemy: BaseEnemy
var TheRopeReleased: bool = false;
var MoveStatus: CONSTANTS.MOVEMENT_STATUS = CONSTANTS.MOVEMENT_STATUS.DOWN

#SIGNALS
signal OnTheRopeReleased;
signal OnEnemyCreated;

func _ready() -> void:
	call_deferred("OnStart")
	
func OnStart() -> void:
	var enemyInstance = ENEMY.instantiate()
	
	Enemy = enemyInstance as BaseEnemy;
	Enemy.position = global_position
	
	if EnemyDefaultGun != null:
		Enemy.SetDefaultGun(EnemyDefaultGun)
	
	get_tree().get_root().get_node("Game").add_child.call_deferred(Enemy)
		
	Enemy.StopEnemyMovementProcessForce()
	Enemy.SlideWithRope(DestinationPointY, OnTheRopeReleased)
	
	OnEnemyCreated.emit(Enemy)

func _process(delta) -> void:
	if(MoveStatus == CONSTANTS.MOVEMENT_STATUS.DOWN):
		if position.y < DestinationPointY:
			var velocity = Vector2.ZERO # The rope's movement vector.
			velocity.y += 1
			if velocity.length() > 0:
				velocity = velocity.normalized() * SPEED
			
			position += velocity * delta
		elif position.y >= DestinationPointY and !TheRopeReleased:
			TheRopeReleased = true
			OnTheRopeReleased.emit(self)
	elif(MoveStatus == CONSTANTS.MOVEMENT_STATUS.WAIT):
		pass
	else:
		if position.y > RollbackAndDestroyPointY:
			var velocity = Vector2.ZERO # The rope's movement vector.
			velocity.y -= 1
			if velocity.length() > 0:
				velocity = velocity.normalized() * ROLLBACK_SPEED
			
			position += velocity * delta
		elif position.y <= RollbackAndDestroyPointY:
			queue_free()
