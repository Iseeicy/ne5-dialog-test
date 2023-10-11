extends Control

func _ready():
	visible = false

func _on_text_reader_reading_started(raw_text, stripped_text, settings):
	visible = false

func _on_text_reader_reading_finished(reason):
	visible = true
