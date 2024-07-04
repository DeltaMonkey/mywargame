class_name BasePlayer extends BaseCharacter

const SPEED = 100.0
const JUMP_VELOCITY = -150.0
const COLLECTED_GUN_DEFAULT: PackedScene = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

@onready var sprite_container = $SpriteContainer as Node2D
@onready var animated_sprite_2d = $SpriteContainer/AnimatedSprite2D as AnimatedSprite2D

func _ready():
	InitilizeCharacter(
		SPEED, 
		JUMP_VELOCITY, 
		animated_sprite_2d, 
		sprite_container,
		COLLECTED_GUN_DEFAULT)

func _physics_process(delta: float):
	ApplyGravity(delta)

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("ui_left", "ui_right")
	MoveTowardsDirection(direction)

	#Handle shoot
	if Input.is_action_pressed("ui_accept"):
		Shoot()
