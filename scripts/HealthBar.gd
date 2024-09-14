extends ProgressBar

#@EXPORTS
@export var Player: BasePlayer

func _ready():
	value = Player.CurrentHealth * 100.0 / Player.MaxHealth
	Player.OnHealthChanged.connect(update)
	
func update():
	value = Player.CurrentHealth * 100.0 / Player.MaxHealth
