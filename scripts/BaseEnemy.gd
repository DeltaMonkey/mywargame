class_name BaseEnemy extends BaseCharacter

const SPEED = 15.0
const JUMP_VELOCITY = -150.0
const COLLECTED_GUN_DEFAULT = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

@onready var sprite_container: Node2D = $SpriteContainer as Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $SpriteContainer/AnimatedSprite2D as AnimatedSprite2D

@onready var timer_to_move: Timer = $TimerToMove as Timer
@onready var timer_to_wait: Timer = $TimerToWait as Timer

@onready var ray_cast_wall_right: RayCast2D = $RayCastWallRight as RayCast2D
@onready var ray_cast_wall_left: RayCast2D = $RayCastWallLeft as RayCast2D
@onready var ray_cast_wall_jump_right = $RayCastWallJumpRight
@onready var ray_cast_wall_jump_left = $RayCastWallJumpLeft


@export var SecondToMove: float = 3
@export var SecondToWait: float = 2
@export var SecondToMoveWhenAlerted: float = 2
@export var SecondToWaitWhenAlerted: float = 1

@export var Direction = 1;
var PreviousDirection = 0

var JumpRandom: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		animated_sprite_2d, 
		sprite_container,
		COLLECTED_GUN_DEFAULT)
	
	timer_to_wait.wait_time = SecondToWait
	timer_to_move.wait_time = SecondToMove
	timer_to_move.connect("timeout", TimeToWait)
	timer_to_wait.connect("timeout", TimeToWalk)

func _physics_process(delta):
	ApplyGravity(delta)
	
	if (Direction != 0 and
	 		(ray_cast_wall_jump_left.is_colliding() or ray_cast_wall_jump_right.is_colliding())):
		# Prints a random integer between 0 and 99.
		if(JumpRandom.randi() % 100 > 75):
			Jump()
	
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
	elif Direction < 0:
		ray_cast_wall_jump_right.enabled = false
		ray_cast_wall_jump_left.enabled = true
		
func TimeToWait():
	PreviousDirection = Direction
	Direction = 0
	timer_to_wait.start()

func TimeToWalk():
	Direction = PreviousDirection * -1;
	timer_to_move.start()
