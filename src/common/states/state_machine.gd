class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
	
	switch_to(initial_state)

func _physics_process(delta: float) -> void:
	current_state.process(delta)

func switch_to(target_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = target_state
	current_state.enter()
