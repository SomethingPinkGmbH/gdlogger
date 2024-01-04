@tool
class_name LoggerEditorPlugin
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton(Logger.AUTOLOAD_NAME, "res://addons/gdlogger/logger.gd")

func _exit_tree():
	remove_autoload_singleton(Logger.AUTOLOAD_NAME)
