class_name IdleEnemyState
extends State

@export var player_observer: Area3D
@export var chase_state: ChaseEnemyState

func enter() -> void:
	player_observer.body_entered.connect(_on_player_entered)

func exit() -> void:
	player_observer.body_entered.disconnect(_on_player_entered)

func _on_player_entered(body: Node3D) -> void:
	if not body is Player:
		return
	
	chase_state.target = body as Player
	state_machine.switch_to(chase_state)
