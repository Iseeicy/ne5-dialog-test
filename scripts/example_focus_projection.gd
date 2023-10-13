extends MeshInstance3D

@export var projection: ControlProjection

func _process(delta):
	projection.set_focus_position(global_position)
