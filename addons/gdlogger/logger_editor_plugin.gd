## This editor plugin will take care of registering the logger as a global autoload service.
@tool
class_name LoggerEditorPlugin
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton(Logger.AUTOLOAD_NAME, "logger.gd")

func _exit_tree() -> void:
	remove_autoload_singleton(Logger.AUTOLOAD_NAME)
