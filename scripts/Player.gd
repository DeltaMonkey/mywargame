class_name BasePlayer extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -150.0

@onready var sprite_container = $SpriteContainer as Node2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var equipped_gun: BaseGun;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

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

	move_and_slide()

	#Handle shoot
	if Input.is_action_just_pressed("ui_accept"):
		self.shoot()

func equip_gun(gun_to_collect: PackedScene):
	equipped_gun = gun_to_collect.instantiate() as BaseGun;
	sprite_container.add_child(equipped_gun)
	print("gun equipped")

func shoot():
	if(equipped_gun):
		equipped_gun.shoot(sprite_container.scale.x);
