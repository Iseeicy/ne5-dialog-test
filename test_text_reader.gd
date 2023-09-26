extends LineEdit

@export var text_reader: TextReader
@export var settings: TextReaderSettings

func _on_text_submitted(new_text):
	text_reader.start_reading(new_text, settings)
