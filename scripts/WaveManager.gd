class_name BaseWaveManager extends Node

const GUN1 = preload("res://scenes/Guns/Collected/CollectedGunPistol.tscn")
const GUN2 = preload("res://scenes/Guns/Collected/CollectedGunAssaultRifle.tscn")
const ROPE = preload("res://scenes/Rope.tscn")

var SpawnPoints: Array[Node2D] = []

# defines how many enemy I should pop_front from WaveEnemyModels
var WaveEnemyCounts: Array[int] = [] 

# defines all enemymodels (enemies actually) to call FIFO
var WaveEnemyModels: Array[WaveManagerEnemyModel] = []

func _ready() -> void:
	GetSpawnPoints()
	
	WaveEnemyCounts = [
		2
#		,3
	]
	
	WaveEnemyModels = [
		#WAVE 1
		WaveManagerEnemyModel.new(GUN1, SpawnPoints[0]),
		WaveManagerEnemyModel.new(GUN1, SpawnPoints[2]),
		#WAVE 2
		WaveManagerEnemyModel.new(GUN1, SpawnPoints[0]),
		WaveManagerEnemyModel.new(GUN2, SpawnPoints[1]),
		WaveManagerEnemyModel.new(GUN1, SpawnPoints[2]),
	]
	
	call_deferred("OnStart")
	
func OnStart() -> void:
	Spawn()

func GetSpawnPoints() -> void:
	SpawnPoints.clear()
	
	for child in get_children():
		if child is Node2D:
			SpawnPoints.append(child as Node2D)

func Spawn() -> void:
	for WaveEnemyCount in WaveEnemyCounts:
		for i in WaveEnemyCount:
			var model: WaveManagerEnemyModel = WaveEnemyModels.pop_front()
			
			var rope: Rope = ROPE.instantiate()
			
			get_tree().get_root().get_node("Game").add_child.call_deferred(rope)
			
			rope.global_position = model.SpawnPoint.global_position
			rope.RollbackAndDestroyPointY = model.SpawnPoint.global_position.y
			rope.DestinationPointY = model.SpawnPoint.get_child(0).global_position.y #DestinationPoint
			rope.EnemyDefaultGun = model.Gun
