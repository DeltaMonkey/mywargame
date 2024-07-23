class_name BaseEnemy extends BaseCharacter

const SPEED = 15.0
const JUMP_VELOCITY = -150.0
const COLLECTED_GUN_DEFAULT = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

@onready var direction_container: Node2D = $DirectionContainer as Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $DirectionContainer/AnimatedSprite2D as AnimatedSprite2D

@onready var timer_to_move: Timer = $TimerToMove as Timer
@onready var timer_to_wait: Timer = $TimerToWait as Timer
@onready var timer_to_jump_cooldown = $TimerToJumpCooldown

@onready var timer_to_alert = $TimerToAlert as Timer
@onready var timer_cooldown_time = $TimerCooldownTime as Timer

@onready var ray_cast_wall_right: RayCast2D = $RayCastWallRight as RayCast2D
@onready var ray_cast_wall_left: RayCast2D = $RayCastWallLeft as RayCast2D
@onready var ray_cast_wall_jump_right: RayCast2D = $RayCastWallJumpRight as RayCast2D
@onready var ray_cast_wall_jump_left: RayCast2D = $RayCastWallJumpLeft as RayCast2D
@onready var ray_cast_stop_wall_jump_right: RayCast2D = $RayCastStopWallJumpRight as RayCast2D
@onready var ray_cast_stop_wall_jump_left: RayCast2D = $RayCastStopWallJumpLeft as RayCast2D

@onready var raycast_enemy_dedector = $DirectionContainer/RaycastEnemyDedector

@export var SecondToMove: float = 3
@export var SecondToWait: float = 2
@export var SecondToMoveWhenAlerted: float = 2
@export var SecondToWaitWhenAlerted: float = 1

@export var Direction = 1;
var PreviousDirection = 0

var JumpRandom: RandomNumberGenerator = RandomNumberGenerator.new()

var IsAlertModeOn: bool = false;

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
	
	if ray_cast_wall_right.is_colliding():
		
		ray_cast_wall_right.enabled = false
		ray_cast_wall_left.enabled = true
		
		timer_to_move.stop()
		timer_to_move.emit_signal("timeout")
		
	elif ray_cast_wall_left.is_colliding():
		
		ray_cast_wall_right.enabled = true
		ray_cast_wall_left.enabled = false
		
		timer_to_move.stop()
		timer_to_move.emit_signal("timeout")
	
	if Direction > 0:
		ray_cast_wall_jump_right.enabled = true
		ray_cast_wall_jump_left.enabled = false
		
		ray_cast_stop_wall_jump_right.enabled = true
		ray_cast_stop_wall_jump_left.enabled = false
		
	elif Direction < 0:
		ray_cast_wall_jump_right.enabled = false
		ray_cast_wall_jump_left.enabled = true
		
		ray_cast_stop_wall_jump_right.enabled = false
		ray_cast_stop_wall_jump_left.enabled = true
	else:
		ray_cast_wall_jump_right.enabled = false
		ray_cast_wall_jump_left.enabled = false
		
		ray_cast_stop_wall_jump_right.enabled = false
		ray_cast_stop_wall_jump_left.enabled = false
	
	CalculateJump()
	
	if(raycast_enemy_dedector.is_colliding()):
		var collision = raycast_enemy_dedector.get_collider() as Node
	
		var is_colliding_with_wall = collision.is_in_group('wall')
	
		if(!is_colliding_with_wall):
			velocity.x = 0;
			animated_sprite_2d.play('idle')
			
			
		if(timer_cooldown_time.time_left == 0 && !is_colliding_with_wall):
			timer_cooldown_time.start()
			Shoot()

	move_and_slide()
	
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

#var JumpRequestCount = 0

func CalculateJump():
	var stopToRightWallCollided = ray_cast_stop_wall_jump_right.is_colliding()
	var stopToLeftWallCollided = ray_cast_stop_wall_jump_left.is_colliding()
		
	if (is_on_floor() and Direction != 0 and
	 		(ray_cast_wall_jump_left.is_colliding() or ray_cast_wall_jump_right.is_colliding())
			and 
			(!stopToLeftWallCollided and !stopToRightWallCollided)):
			
			
		if(timer_to_jump_cooldown.time_left <= 0):
			Jump()
			timer_to_jump_cooldown.start()
			timer_to_jump_cooldown.wait_time = randf_range(3, 6)

func _on_timer_to_alert_timeout():
	IsAlertModeOn = false
	
func Shoot():
	super()
