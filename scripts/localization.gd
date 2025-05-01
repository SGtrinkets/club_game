extends Node

signal language_changed

func set_language(locale: String) -> void:
	TranslationServer.set_locale(locale)
	language_changed.emit()
