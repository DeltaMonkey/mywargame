class_name BaseEnemy extends BaseCharacter

#CONSTS
const SPEED = 6.0 #should be even number to avoid shaking
const JUMP_VELOCITY = 4
const ROPE_SLIDE_SPEED = 28.0

#@ONREADIES
@onready var DirectionContainerNode: Node2D = $DirectionContainer as Node2D
@onready var CollectedGunContainerNode: Node2D = $DirectionContainer/CollectedGunContainer
@onready var AnimatedSprite2DNode: AnimatedSprite2D = $DirectionContainer/AnimatedSprite2D as AnimatedSprite2D
@onready var TimerToMove: Timer = $TimerToMove as Timer
@onready var TimerToWait: Timer = $TimerToWait as Timer
@onready var TimerToAlert = $TimerToAlert as Timer
@onready var TimerCooldownTime = $TimerCooldownTime as Timer
@onready var TimerShockToShoot = $TimerShockToShoot as Timer
@onready var RayCastWallRight: RayCast2D = $RayCastWallRight as RayCast2D
@onready var RayCastWallLeft: RayCast2D = $RayCastWallLeft as RayCast2D
@onready var RaycastEnemyDetector = $DirectionContainer/RaycastEnemyDetector
@onready var EnemyCollisionShape: CollisionShape2D = $CollisionShape2D

#@EXPORTS
@export var SecondToMove: float = 25
@export var SecondToWait: float = 2
@export var SecondToMoveWhenAlerted: float = 2
@export var SecondToWaitWhenAlerted: float = 1
@export var StopWalking = false
@export var Direction: int = 1
@export var CollectedGunDefault = preload("res://scenes/Guns/Collected/CollectedGunPistol.tscn")

#VARS
var ReparentNode: Node
var DeleteOldParentNodeRef: Node
var DeleteOldParentNode: Node
var EnemysRope: Rope
var PreviousDirection: int = 0
var JumpRandom: RandomNumberGenerator = RandomNumberGenerator.new()
var IsAlertModeOn: bool = false;
var IsEnemyShouldDelayToShoot: bool = true
var IsStopEnemyMovementProcessForce: bool = false
var EnemyRopeSlidingDestinationPointY: int = 0
var CheckEnemyRopeSlidingDestinationPointY: bool = false

func _ready() -> void:
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		AnimatedSprite2DNode, 
		DirectionContainerNode,
		CollectedGunContainerNode,
		CollectedGunDefault)
		
	TimerToWait.wait_time = SecondToWait
	TimerToMove.wait_time = SecondToMove
	TimerToMove.connect("timeout", TimeToWait)
	TimerToWait.connect("timeout", TimeToWalk)
	
	if IsStopEnemyMovementProcessForce:
		DisableCollisionAndRaygcasts()
	
	EquipGun(CollectedGunDefault)

func _physics_process(delta) -> void:
		
	ApplyGravity(delta)
		
	MoveTowardsDirection(Direction)
		
	if RayCastWallRight.is_colliding() || RayCastWallLeft.is_colliding():
		TimerToMove.stop()
		TimerToMove.emit_signal("timeout")
		
	if Direction == 1:
		RayCastWallRight.enabled = true
		RayCastWallLeft.enabled = false
	elif Direction == -1: 
		RayCastWallRight.enabled = false
		RayCastWallLeft.enabled = true
	else:
		RayCastWallRight.enabled = false
		RayCastWallLeft.enabled = false
		
	if(RaycastEnemyDetector.is_colliding()):
		var collision = RaycastEnemyDetector.get_collider() as Node
			
		var is_colliding_with_wall = collision.is_in_group(Constants.GROUPS_WALL)
		var is_colliding_with_player = collision.is_in_group(Constants.GROUPS_PLAYER)
			
		if(!is_colliding_with_wall && is_colliding_with_player):
			ActivateAlertMode();
			velocity.x = 0;
			if(AnimatedSprite2DNode.animation != Constants.CHARACTER_MOVEMENT_ANIMATIONS_HURT):
				PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_IDLE)
			
		if(TimerCooldownTime.time_left == 0 && !is_colliding_with_wall && is_colliding_with_player):
			TimerCooldownTime.start()
				
			if IsEnemyShouldDelayToShoot == true:
				TimerShockToShoot.start()
				IsEnemyShouldDelayToShoot = false
			else:
				Shoot()
			
	move_and_slide()
	DeleteOldParentNodeIfNotNull() #ReparentIfReparentNodeNotNull dan önce çalışmalı ki bir sonraki elde silsin
	ReparentIfReparentNodeNotNull(DeleteOldParentNodeRef)
	
	if(CheckEnemyRopeSlidingDestinationPointY && position.y >= EnemyRopeSlidingDestinationPointY):
		StartEnemyMovementProcessForce()
		CheckEnemyRopeSlidingDestinationPointY = false
		EnemysRope.MoveStatus = CONSTANTS.MOVEMENT_STATUS.UP

func TimeToWait() -> void:
	PreviousDirection = Direction
	Direction = 0
	TimerToWait.start()

func TimeToWalk() -> void:
	if StopWalking:
		Direction = 0
	else: 
		if PreviousDirection == 0:
			var possibleDirections = [-1,1]
			var possibleDirection = possibleDirections[randi() % possibleDirections.size()]
			SetEnemyPreviousDirection(possibleDirection)
		
		Direction = PreviousDirection * -1;
		
	TimerToMove.start()

func Shoot() -> void:
	super()

func ReparentIfReparentNodeNotNull(deleteOldParentNode: Node2D = null) -> void:
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
		TimerToWait.wait_time = SecondToWait * 0.5
		TimerToMove.wait_time = SecondToMove * 0.5
		TimerToAlert.stop()
		TimerToAlert.start()
	IsAlertModeOn = true

func DeactivateAlertMode():
	if IsAlertModeOn:
		Speed = SPEED
		TimerToWait.wait_time = SecondToWait
		TimerToMove.wait_time = SecondToMove
	IsAlertModeOn = false
	IsEnemyShouldDelayToShoot = true

func StopEnemyMovementProcessForce():
	gravity = 0
	velocity.y = 0
	velocity.x = 0
	Direction = 0
	StopWalking = true
	IsStopEnemyMovementProcessForce = true
	DisableCollisionAndRaygcasts()

func StartEnemyMovementProcessForce() -> void:
	gravity = DEFAULT_GRAVITY
	velocity.y = 0
	velocity.x = 0
	Direction = PreviousDirection
	StopWalking = false
	IsStopEnemyMovementProcessForce = false
	EnableCollisionAndRaygcasts()

func SlideWithRope(destination_point_y: int, Rope_OnTheRopeReleased: Signal) -> void:
	velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * ROPE_SLIDE_SPEED
	
	EnemyRopeSlidingDestinationPointY = destination_point_y
	CheckEnemyRopeSlidingDestinationPointY = true
	
	Rope_OnTheRopeReleased.connect(OnTheRopeReleased)

func DisableCollisionAndRaygcasts() -> void:
	if RaycastEnemyDetector:
		RaycastEnemyDetector.enabled = false
	if RayCastWallLeft:
		RayCastWallLeft.enabled = false
	if RayCastWallRight: 
		RayCastWallRight.enabled = false
	if EnemyCollisionShape: 
		EnemyCollisionShape.disabled = true

func EnableCollisionAndRaygcasts() -> void:
	if RaycastEnemyDetector:
		RaycastEnemyDetector.enabled = true
	if RayCastWallLeft:
		RayCastWallLeft.enabled = true
	if RayCastWallRight: 
		RayCastWallRight.enabled = true
	if EnemyCollisionShape: 
		EnemyCollisionShape.disabled = false

func OnTheRopeReleased(rope: Rope) -> void:
	var possibleDirections = [-1,1]
	var possibleDirection = possibleDirections[randi() % possibleDirections.size()]
	SetEnemyPreviousDirection(possibleDirection)
	EnemysRope = rope
	EnemysRope.MoveStatus = CONSTANTS.MOVEMENT_STATUS.WAIT

func SetEnemyDirection(direction: int) -> void:
	Direction = direction

func SetEnemyPreviousDirection(direction: int) -> void:
	PreviousDirection = direction

func GetEnemyPreviousDirection() -> int:
	return PreviousDirection

func _on_TimerToAlert_timeout():
	DeactivateAlertMode();

func _on_TimerShockToShoot_timeout():
	Shoot()
