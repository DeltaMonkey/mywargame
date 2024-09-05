class_name BaseEnemy extends BaseCharacter

const SPEED = 6.0 #should be even number to avoid shaking
const JUMP_VELOCITY = 4
const ROPE_SLIDE_SPEED = 28.0

@onready var direction_container: Node2D = $DirectionContainer as Node2D
@onready var collected_gun_container: Node2D = $DirectionContainer/CollectedGunContainer
@onready var animated_sprite_2d: AnimatedSprite2D = $DirectionContainer/AnimatedSprite2D as AnimatedSprite2D

@onready var timer_to_move: Timer = $TimerToMove as Timer
@onready var timer_to_wait: Timer = $TimerToWait as Timer

@onready var timer_to_alert = $TimerToAlert as Timer
@onready var timer_cooldown_time = $TimerCooldownTime as Timer

@onready var timer_shock_to_shoot = $TimerShockToShoot as Timer

@onready var ray_cast_wall_right: RayCast2D = $RayCastWallRight as RayCast2D
@onready var ray_cast_wall_left: RayCast2D = $RayCastWallLeft as RayCast2D

@onready var raycast_enemy_dedector = $DirectionContainer/RaycastEnemyDedector

@onready var enemy_collision_shape: CollisionShape2D = $CollisionShape2D

@export var SecondToMove: float = 25
@export var SecondToWait: float = 2
@export var SecondToMoveWhenAlerted: float = 2
@export var SecondToWaitWhenAlerted: float = 1

@export var StopWalking = false

@export var Direction: int = 1
var PreviousDirection: int = 0

@export var collected_gun_default = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

var JumpRandom: RandomNumberGenerator = RandomNumberGenerator.new()

var IsAlertModeOn: bool = false;

var ReparentNode: Node
var DeleteOldParentNodeRef: Node
var DeleteOldParentNode: Node

var IsEnemyShouldDelayToShoot: bool = true

var _IsStopEnemyMovementProcess_Force: bool = false

var EnemyRopeSlidingDestination_Point_Y: int = 0
var CheckEnemyRopeSlidingDestination_Point_Y: bool = false

var EnemysRope: Rope

func _ready():
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		animated_sprite_2d, 
		direction_container,
		collected_gun_container,
		collected_gun_default)
		
	timer_to_wait.wait_time = SecondToWait
	timer_to_move.wait_time = SecondToMove
	timer_to_move.connect("timeout", TimeToWait)
	timer_to_wait.connect("timeout", TimeToWalk)
	
	if _IsStopEnemyMovementProcess_Force:
		DisableCollisionAndRaygcasts()
	
	EquipGun(collected_gun_default)

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
			
		var is_colliding_with_wall = collision.is_in_group("wall")
		var is_colliding_with_player = collision.is_in_group("player")
			
		if(!is_colliding_with_wall && is_colliding_with_player):
			ActivateAlertMode();
			velocity.x = 0;
			if(AnimatedSprite2D_Node.animation != "hurt"):
				PlayAnimation("idle")
			
			
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
	
	if(CheckEnemyRopeSlidingDestination_Point_Y && position.y >= EnemyRopeSlidingDestination_Point_Y):
		StartEnemyMovementProcess_Force()
		CheckEnemyRopeSlidingDestination_Point_Y = false
		EnemysRope.MoveStatus = Rope.MOVEMENT_STATUS.UP
	
func TimeToWait():
	PreviousDirection = Direction
	Direction = 0
	timer_to_wait.start()

func TimeToWalk():
	if StopWalking:
		Direction = 0
	else: 
		if PreviousDirection == 0:
			var possibleDirections = [-1,1]
			var possibleDirection = possibleDirections[randi() % possibleDirections.size()]
			SetEnemyPreviousDirection(possibleDirection)
		
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
	
func StopEnemyMovementProcess_Force():
	gravity = 0
	velocity.y = 0
	velocity.x = 0
	Direction = 0
	StopWalking = true
	_IsStopEnemyMovementProcess_Force = true
	DisableCollisionAndRaygcasts()
	
func StartEnemyMovementProcess_Force():
	gravity = DEFAULT_GRAVITY
	velocity.y = 0
	velocity.x = 0
	Direction = PreviousDirection
	StopWalking = false
	_IsStopEnemyMovementProcess_Force = false
	EnableCollisionAndRaygcasts()
	
func SlideWithRope(destination_point_y: int, Rope_OnTheRopeReleased: Signal):
	velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * ROPE_SLIDE_SPEED
	
	EnemyRopeSlidingDestination_Point_Y = destination_point_y
	CheckEnemyRopeSlidingDestination_Point_Y = true
	
	Rope_OnTheRopeReleased.connect(OnTheRopeReleased)
		
func DisableCollisionAndRaygcasts():
	if raycast_enemy_dedector:
		raycast_enemy_dedector.enabled = false
	if ray_cast_wall_left:
		ray_cast_wall_left.enabled = false
	if ray_cast_wall_right: 
		ray_cast_wall_right.enabled = false
	if enemy_collision_shape: 
		enemy_collision_shape.disabled = true
		
func EnableCollisionAndRaygcasts():
	if raycast_enemy_dedector:
		raycast_enemy_dedector.enabled = true
	if ray_cast_wall_left:
		ray_cast_wall_left.enabled = true
	if ray_cast_wall_right: 
		ray_cast_wall_right.enabled = true
	if enemy_collision_shape: 
		enemy_collision_shape.disabled = false
	
func OnTheRopeReleased(rope: Rope):
	var possibleDirections = [-1,1]
	var possibleDirection = possibleDirections[randi() % possibleDirections.size()]
	SetEnemyPreviousDirection(possibleDirection)
	EnemysRope = rope
	EnemysRope.MoveStatus = Rope.MOVEMENT_STATUS.WAIT

func SetEnemyDirection(direction: int):
	Direction = direction
	
func SetEnemyPreviousDirection(direction: int):
	PreviousDirection = direction
	
func GetEnemyPreviousDirection() -> int:
	return PreviousDirection
