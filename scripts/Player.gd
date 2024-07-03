class_name BasePlayer extends BaseCharacter

const SPEED = 100.0
const JUMP_VELOCITY = -150.0
const COLLECTED_GUN_DEFAULT = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

@onready var sprite_container = $SpriteContainer as Node2D
@onready var animated_sprite_2d = $SpriteContainer/AnimatedSprite2D as AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var Gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var EquippedGun: BaseGun;

func _ready():
	InitilizeCharacter(animated_sprite_2d)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += Gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0 and sprite_container.scale != Vector2(1, 1): sprite_container.set_scale(Vector2(1, 1))
		elif direction < 0 and sprite_container.scale != Vector2(-1, 1): sprite_container.set_scale(Vector2(-1, 1))
		
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0 and animated_sprite_2d.animation != 'walk':
		animated_sprite_2d.play("walk")
	elif velocity.x == 0 and animated_sprite_2d.animation != 'idle':
		animated_sprite_2d.play('idle')
	
	if !is_on_floor() and animated_sprite_2d.animation != 'jump':
		animated_sprite_2d.play('jump')
		
	move_and_slide()

	#Handle shoot
	if Input.is_action_pressed("ui_accept"):
		self.Shoot()

func EquipGun(gunToCollect: PackedScene):
	if EquippedGun != null:
		EquippedGun.queue_free()
		
	EquippedGun = gunToCollect.instantiate() as BaseGun;
	sprite_container.add_child(EquippedGun)

func Shoot():
	if(EquippedGun):
		var remainingBullet = EquippedGun.Shoot(sprite_container.scale.x);
		
		if(remainingBullet == 0):
			EquipGun(COLLECTED_GUN_DEFAULT)
