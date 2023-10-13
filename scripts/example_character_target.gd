extends Node
class_name ExampleCharacterTarget

#
#	Exported
#

@export var track_to_node: Node
@export var character: CharacterDefinition

#
#	Godot Functions
#

func _ready():
	if !track_to_node:
		track_to_node = get_parent()
	
	if character:
		character.set_tracked_node(track_to_node)
