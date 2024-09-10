extends Area2D

#@EXPORTS
@export var HealthContaining: int = 10

#@ONREADIES
@onready var RaycastAreaColliderNode: CollisionShape2D = $CollisionShape2D

#VARS
var collisions: Array[BasePlayer] = []

func _physics_process(delta: float) -> void:
	if(collisions.size() > 0):
		for player: BasePlayer in collisions:
			if player.CurrentHealth < player.MaxHealth:
				player.IncreaseHealth(HealthContaining)
				queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.is_in_group(Constants.GROUPS_PLAYER)
	var player = body as BasePlayer
	collisions.append(player)

func _on_body_exited(body: Node2D) -> void:
	collisions.erase(body)
