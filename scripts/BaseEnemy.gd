class_name BaseEnemy extends BaseCharacter

const SPEED = 10.0
const JUMP_VELOCITY = 4
const COLLECTED_GUN_DEFAULT = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

@onready var direction_container: Node2D = $DirectionContainer as Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $DirectionContainer/AnimatedSprite2D as AnimatedSprite2D

@onready var timer_to_move: Timer = $TimerToMove as Timer
@onready var timer_to_wait: Timer = $TimerToWait as Timer

@onready var timer_to_alert = $TimerToAlert as Timer
@onready var timer_cooldown_time = $TimerCooldownTime as Timer

@onready var timer_shock_to_shoot = $TimerShockToShoot as Timer

@onready var ray_cast_wall_right: RayCast2D = $RayCastWallRight as RayCast2D
@onready var ray_cast_wall_left: RayCast2D = $RayCastWallLeft as RayCast2D

@onready var raycast_enemy_dedector = $DirectionContainer/RaycastEnemyDedector

@export var SecondToMove: float = 25
@export var SecondToWait: float = 2
@export var SecondToMoveWhenAlerted: float = 2
@export var SecondToWaitWhenAlerted: float = 1

@export var Direction = 1;
var PreviousDirection = 0

var JumpRandom: RandomNumberGenerator = RandomNumberGenerator.new()

var IsAlertModeOn: bool = false;

var ReparentNode: Node
var DeleteOldParentNodeRef: Node
var DeleteOldParentNode: Node

var IsEnemyShouldDelayToShoot: bool = true
	
func _ready():
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		animated_sprite_2d, 
		direction_container,
		COLLECTED_GUN_DEFAULT)
		
	timer_to_wait.wait_time = SecondToWait
	timer_to_move.wait_time = SecondToMove
	timer_to_move.connect("timeout", TimeToWait)
	timer_to_wait.connect("timeout", TimeToWalk)

func _physics_process(delta):
		
	ApplyGravity(delta)
		
	MoveTowardsDirection(Direction)
		
	if ray_cast_wall_right.is_colliding() || ray_cast_wall_left.is_colliding():
		timer_to_move.stop()
		timer_to_move.emit_signal("timeout")
		
	if Direction == 1:
		ray_cast_wall_right.enabled = true
		ray_cast_wall_left.enabled = false
	elif Direction == -1: 
		ray_cast_wall_right.enabled = false
		ray_cast_wall_left.enabled = true
	else:
		ray_cast_wall_right.enabled = false
		ray_cast_wall_left.enabled = false
		
	CalculateJump()
		
	if(raycast_enemy_dedector.is_colliding()):
		var collision = raycast_enemy_dedector.get_collider() as Node
			
		var is_colliding_with_wall = collision.is_in_group('wall')
		var is_colliding_with_player = collision.is_in_group('player')
			
		if(!is_colliding_with_wall && is_colliding_with_player):
			ActivateAlertMode();
			velocity.x = 0;
			animated_sprite_2d.play('idle')
			
			
		if(timer_cooldown_time.time_left == 0 && !is_colliding_with_wall && is_colliding_with_player):
			timer_cooldown_time.start()
				
			if IsEnemyShouldDelayToShoot == true:
				timer_shock_to_shoot.start()
				IsEnemyShouldDelayToShoot = false
			else:
				Shoot()
			
	move_and_slide()
	DeleteOldParentNodeIfNotNull() #ReparentIfReparentNodeNotNull dan önce çalışmalı ki bir sonraki elde silsin
	ReparentIfReparentNodeNotNull(DeleteOldParentNodeRef)
	
func TimeToWait():
	PreviousDirection = Direction
	Direction = 0
	timer_to_wait.start()

func TimeToWalk():
	if PreviousDirection == 0:
		var possibleDirections = [-1,1]
		var possibleDirection = possibleDirections[randi() % possibleDirections.size()]
		PreviousDirection = possibleDirection
		
	Direction = PreviousDirection * -1;
	timer_to_move.start()
	
func CalculateJump():
	pass;
	
func _on_timer_to_alert_timeout():
	DeactivateAlertMode();
	
func Shoot():
	super()
	
func ReparentIfReparentNodeNotNull(deleteOldParentNode: Node2D = null):
	if ReparentNode:
		reparent(ReparentNode)
		ReparentNode = null
	
	if deleteOldParentNode:
		DeleteOldParentNode = deleteOldParentNode
	
func DeleteOldParentNodeIfNotNull():
	if DeleteOldParentNode:
		DeleteOldParentNode.queue_free()
		DeleteOldParentNodeRef = null;
		DeleteOldParentNode = null;
		
func ActivateAlertMode():
	if !IsAlertModeOn:
		Speed = Speed * 2
		timer_to_wait.wait_time = SecondToWait * 0.5
		timer_to_move.wait_time = SecondToMove * 0.5
		timer_to_alert.stop()
		timer_to_alert.start()
	IsAlertModeOn = true
	
func DeactivateAlertMode():
	if IsAlertModeOn:
		Speed = SPEED
		timer_to_wait.wait_time = SecondToWait
		timer_to_move.wait_time = SecondToMove
	IsAlertModeOn = false
	IsEnemyShouldDelayToShoot = true
	
func _on_timer_shock_to_shoot_timeout():
	Shoot()
