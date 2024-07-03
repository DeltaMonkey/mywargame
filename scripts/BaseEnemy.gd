class_name BaseEnemy extends BaseCharacter

const SPEED = 100.0
const JUMP_VELOCITY = -150.0

@onready var animated_sprite_2d = $SpriteContainer/AnimatedSprite2D as AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	InitilizeCharacter(animated_sprite_2d)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
