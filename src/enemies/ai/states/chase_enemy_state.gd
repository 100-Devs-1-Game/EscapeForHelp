class_name ChaseEnemyState
extends State

@export var idle: IdleEnemyState
@export var body: CharacterBody3D
@export var agent: NavigationAgent3D

var target: Player

func enter() -> void:
	target = Global.player
	
func process(delta: float) -> void:
	if not agent.is_target_reachable():
		state_machine.switch_to(idle)
		return
	
	agent.target_position = target.global_position
	var point := agent.get_next_path_position()
	var movement := point - body.global_position
	movement.y = 0
	var direction := movement.normalized()
	body.velocity = direction
	body.move_and_slide()
