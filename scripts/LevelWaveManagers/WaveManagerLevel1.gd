class_name WaveManagerLevel1 extends BaseWaveManager

var LEVEL_2 = preload("res://scenes/Level2.tscn")

func _ready() -> void:
	InitilizeWaveManager()
	
	WaveEnemyCounts = [
		2,
		3
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
	
func OnStart():
	NextLevel = LEVEL_2
