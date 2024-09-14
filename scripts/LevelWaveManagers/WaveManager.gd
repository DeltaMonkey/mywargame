class_name BaseWaveManager extends Node

const GUN1 = preload("res://scenes/Guns/Collected/CollectedGunPistol.tscn")
const GUN2 = preload("res://scenes/Guns/Collected/CollectedGunAssaultRifle.tscn")
const ROPE = preload("res://scenes/Rope.tscn")

var SpawnPoints: Array[Node2D] = []

# defines how many enemy I should pop_front from WaveEnemyModels
var WaveEnemyCounts: Array[int] = [] 

# defines all enemymodels (enemies actually) to call FIFO
var WaveEnemyModels: Array[WaveManagerEnemyModel] = []

var SpawnedEnemies: Array[BaseEnemy] = []

var Initilized: bool = false

func InitilizeWaveManager():
	GetSpawnPoints()
	Initilized = true

func OnStart() -> void:
	if Initilized:
		Spawn()

func _process(delta: float) -> void:
	if SpawnedEnemies.size() <= 0 && Initilized:
		Spawn()

func GetSpawnPoints() -> void:
	SpawnPoints.clear()
	
	for child in get_children():
		if child is Node2D:
			SpawnPoints.append(child as Node2D)

func Spawn() -> void:
	if WaveEnemyCounts.size() > 0:
		var waveEnemyCount: int = WaveEnemyCounts.pop_front()
		for i in waveEnemyCount:
			var model: WaveManagerEnemyModel = WaveEnemyModels.pop_front()
			
			var rope: Rope = ROPE.instantiate()
			
			get_tree().get_root().get_node("Game").add_child.call_deferred(rope)
			
			rope.global_position = model.SpawnPoint.global_position
			rope.RollbackAndDestroyPointY = model.SpawnPoint.global_position.y
			rope.DestinationPointY = model.SpawnPoint.get_child(0).global_position.y #DestinationPoint
			rope.EnemyDefaultGun = model.Gun
			
			rope.OnEnemyCreated.connect(EnemySpawned)

func EnemySpawned(enemy: BaseEnemy):
	SpawnedEnemies.append(enemy)
	enemy.OnKilled.connect(EnemyDied)

func EnemyDied(enemy: BaseEnemy):
	SpawnedEnemies.erase(enemy)
