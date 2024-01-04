@tool
class_name Logger extends Node

enum Level {
	ERROR,
	WARNING,
	INFO
}

class Message:
	var level: Logger.Level
	var time: float
	var message: String

	func _init(_level: Logger.Level, _time: float, _message: String):
		level = _level
		time = _time
		message = _message

signal message_received

func log_message(message: Message):
	message_received.emit(message)

func info(_message: String):
	log_message(Message.new(Logger.Level.INFO, Time.get_unix_time_from_system(), _message))
	print("%s\tINFO\t%s"%[Time.get_datetime_string_from_system(), _message])

func warning(_message: String):
	log_message(Message.new(Logger.Level.WARNING, Time.get_unix_time_from_system(), _message))
	printerr("%s\tWARNING\t%s"%[Time.get_datetime_string_from_system(),_message])

func error(_message: String):
	log_message(Message.new(Logger.Level.ERROR, Time.get_unix_time_from_system(), _message))
	printerr("%s\tERROR\t%s"%[Time.get_datetime_string_from_system(), _message])

const AUTOLOAD_NAME = "LoggerService"

static func get_service(requester: Node) -> Logger:
	return requester.get_tree().get_root().get_node(AUTOLOAD_NAME)
