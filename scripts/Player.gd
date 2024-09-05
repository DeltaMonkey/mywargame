class_name BasePlayer extends BaseCharacter

const SPEED = 50.0
const JUMP_VELOCITY = -175.0
const COLLECTED_GUN_DEFAULT: PackedScene = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

@onready var direction_container = $DirectionContainer as Node2D
@onready var collected_gun_container = $DirectionContainer/CollectedGunConatiner as Node2D
@onready var animated_sprite_2d = $DirectionContainer/AnimatedSprite2D as AnimatedSprite2D

var LaddersColliding: Array[bool] = [];
var ClimbedToLadder: bool = false

func _ready():
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		animated_sprite_2d, 
		direction_container,
		collected_gun_container,
		COLLECTED_GUN_DEFAULT)

func _physics_process(delta: float):
	ApplyGravity(delta)

 	# Handle ladder
	if Input.is_action_pressed("ui_up") and LaddersColliding.size() > 0:
		velocity.y = -20
		if(AnimatedSprite2D_Node.animation != "climb"):
			PlayAnimation("climb", "climb")
		if(AnimatedSprite2D_Node.animation == "climb"):
			AnimatedSprite2D_Node.play()
		ClimbedToLadder = true
		BlockAnimationPlay = true
		CollectedGunContainer.visible = false
	elif !is_on_floor() and LaddersColliding.size() > 0 and ClimbedToLadder:
		AnimatedSprite2D_Node.pause()
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and LaddersColliding.size() <= 0:
		Jump()
	
	## Reset laddget status
	#if IsCollideWithLadder and is_on_floor():
		#gravity = DEFAULT_GRAVITY
		#IsCollideWithLadder = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("ui_left", "ui_right")
	MoveTowardsDirection(direction)
	
	move_and_slide()
	
	#Handle shoot
	if Input.is_action_pressed("ui_accept"):
		if(!is_on_floor() and 
		LaddersColliding.size() > 0 and 
		ClimbedToLadder):
			pass
		else:
			Shoot()
		
func LaddersCollidingAppend():
	LaddersColliding.append(true)
	
	
func LaddersCollidingPopFirst():
	LaddersColliding.pop_front()
	if(LaddersColliding.size() <= 0):
		BlockAnimationPlay = false
		ClimbedToLadder = false
		CollectedGunContainer.visible = true
	if is_on_floor():
		BlockAnimationPlay = false
		ClimbedToLadder = false
		CollectedGunContainer.visible = true
