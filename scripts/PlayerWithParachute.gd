class_name PlayerWithParachute extends Node2D

#CONSTS
const SPEED: int = 30
const ROLLBACK_SPEED: int = 60
const PLAYER = preload("res://scenes/Player.tscn")
@onready var FollowCamNode: FollowCam = $FollowCam

#@ONREADIES
@export var DestinationPointY: float = 0.0
@export var PlayerDefaultGun: PackedScene = null;
@export var TileMapLayerNode: TileMapLayer = null;

#VARS
var Player: BasePlayer
var ReachedTheSpawnPoint: bool = false;
var MoveStatus: CONSTANTS.MOVEMENT_STATUS = CONSTANTS.MOVEMENT_STATUS.DOWN

#SIGNALS
signal OnPlayerCreated;

func _ready() -> void:
	SetFollowCamTileMapAndInitCam(TileMapLayerNode)

func _process(delta) -> void:
	
	if position.y < DestinationPointY:
		var velocity = Vector2.ZERO # The rope's movement vector.
		velocity.y += 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
		
		position += velocity * delta
	elif position.y >= DestinationPointY and !ReachedTheSpawnPoint:
		ReachedTheSpawnPoint = true
		
		var playerInstance = PLAYER.instantiate()
	
		Player = playerInstance as BasePlayer;
		Player.position = global_position
		
		
		get_tree().get_root().get_node("Game").add_child.call_deferred(Player)
		
		if PlayerDefaultGun != null:
			Player.EquipGun.call_deferred(PlayerDefaultGun)
			
		Player.SetFollowCamTileMapAndInitCam.call_deferred(TileMapLayerNode)
			
		OnPlayerCreated.emit(Player)
		
		queue_free()

func SetFollowCamTileMapAndInitCam(tileMapLayerNode: TileMapLayer):
	FollowCamNode.TileMapLayerNode = tileMapLayerNode
	FollowCamNode.InitilizeFollowCam()
