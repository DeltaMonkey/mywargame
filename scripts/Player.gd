class_name BasePlayer extends BaseCharacter

#CONSTS
const SPEED: float = 50.0
const JUMP_VELOCITY: float = -175.0
const COLLECTED_GUN_DEFAULT: PackedScene = preload("res://scenes/Guns/Collected/CollectedGunPistol.tscn")

#@ONREADIES
@onready var DirectionContainerNode = $DirectionContainer as Node2D
@onready var CollectedGunContainerNode = $DirectionContainer/CollectedGunConatiner as Node2D
@onready var AnimatedSprite2DNode = $DirectionContainer/AnimatedSprite2D as AnimatedSprite2D
@onready var FollowCamNode: FollowCam = $FollowCam

#VARS
var LaddersColliding: Array[bool] = [];
var ClimbedToLadder: bool = false

func _ready() -> void:
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		AnimatedSprite2DNode, 
		DirectionContainerNode,
		CollectedGunContainerNode,
		COLLECTED_GUN_DEFAULT)

func _physics_process(delta: float) -> void:
	ApplyGravity(delta)

 	# Handle ladder
	if Input.is_action_pressed("ui_up") and LaddersColliding.size() > 0:
		velocity.y = -20
		if(AnimatedSprite2DNode.animation != Constants.CHARACTER_MOVEMENT_ANIMATIONS_CLIMB):
			PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_CLIMB, Constants.CHARACTER_MOVEMENT_ANIMATIONS_CLIMB)
		if(AnimatedSprite2DNode.animation == Constants.CHARACTER_MOVEMENT_ANIMATIONS_CLIMB):
			AnimatedSprite2DNode.play()
		ClimbedToLadder = true
		BlockAnimationPlay = true
		CollectedGunContainerNode.visible = false
	elif !is_on_floor() and LaddersColliding.size() > 0 and ClimbedToLadder:
		AnimatedSprite2DNode.pause()
	elif is_on_floor():
		BlockAnimationPlay = false
		ClimbedToLadder = false
		CollectedGunContainerNode.visible = true
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and LaddersColliding.size() <= 0:
		Jump()
	
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

func LaddersCollidingAppend() -> void:
	LaddersColliding.append(true)

func LaddersCollidingPopFirst() -> void:
	LaddersColliding.pop_front()
	if(LaddersColliding.size() <= 0):
		BlockAnimationPlay = false
		ClimbedToLadder = false
		CollectedGunContainerNode.visible = true
		
func SetDefaultGun(gunPackedScene: PackedScene) -> void:
	CollectedDefaultGun = gunPackedScene

func SetFollowCamTileMapAndInitCam(tileMapLayerNode: TileMapLayer):
	FollowCamNode.TileMapLayerNode = tileMapLayerNode
	FollowCamNode.InitilizeFollowCam()
