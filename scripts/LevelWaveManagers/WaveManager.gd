class_name BaseWaveManager extends Node

const GUN1 = preload("res://scenes/Guns/Collected/CollectedGunPistol.tscn")
const GUN2 = preload("res://scenes/Guns/Collected/CollectedGunAssaultRifle.tscn")
const GUN3 = preload("res://scenes/Guns/Collected/CollectedGunShotGun.tscn") #TODO: NEED TO USE
const ROPE = preload("res://scenes/Rope.tscn")

var NextLevel: PackedScene;
var SpawnPoints: Array[Node2D] = []

var WaveEnemyCounts: Array[int] = []  # defines how many enemy I should pop_front from WaveEnemyModels
var WaveEnemyModels: Array[WaveManagerEnemyModel] = [] # defines all enemymodels (enemies actually) to call FIFO
var SpawnedEnemies: Array[BaseEnemy] = []
var Initilized: bool = false

func InitilizeWaveManager():
	GetSpawnPoints()
	Initilized = true

func _process(_delta: float) -> void:
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
	else:
		#Next level time
		get_tree().change_scene_to_packed(NextLevel)
		
func EnemySpawned(enemy: BaseEnemy):
	SpawnedEnemies.append(enemy)
	enemy.OnKilled.connect(EnemyDied)

func EnemyDied(enemy: BaseEnemy):
	SpawnedEnemies.erase(enemy)
