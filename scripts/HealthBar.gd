extends ProgressBar

#@EXPORTS
@export var Player: BasePlayer
@onready var PlayerWithParachuteNode: PlayerWithParachute = $"../../PlayerWithParachute"

func _ready() -> void:
	value = max_value;
	PlayerWithParachuteNode.OnPlayerCreated.connect(InitializeProgressBar)

func InitializeProgressBar(player: BasePlayer):
	if player:
		Player = player;
		value = Player.CurrentHealth * 100.0 / Player.MaxHealth
		Player.OnHealthChanged.connect(update)
	
func update():
	value = Player.CurrentHealth * 100.0 / Player.MaxHealth
