## Logger is a tool to write log messages to the console and forward to message listeners.
@tool
class_name Logger extends Node

## This constant contains the name under which the autoload will be registred by the plugin.
const AUTOLOAD_NAME: String = "LoggerService"

## Hook to process log messages. The signal will receive the Message as a parameter.
signal message_received

## This function logs a generic message with an arbitrary log level.
func log_message(message: Message) -> void:
	message_received.emit(message)

## Debug logs at the debug log level. This should be used sparingly only if needed.
func debug(_message: String) -> void:
	log_message(Message.new(Logger.Level.DEBUG, Time.get_unix_time_from_system(), _message))
	print_verbose("%s\tDEBUG\t%s"%[Time.get_datetime_string_from_system(), _message])

## This function logs informational, but still important messages.
func info(_message: String) -> void:
	log_message(Message.new(Logger.Level.INFO, Time.get_unix_time_from_system(), _message))
	print("%s\tINFO\t%s"%[Time.get_datetime_string_from_system(), _message])

## This function logs warning messages that convey a potentially problematic information.
func warning(_message: String) -> void:
	log_message(Message.new(Logger.Level.WARNING, Time.get_unix_time_from_system(), _message))
	printerr("%s\tWARNING\t%s"%[Time.get_datetime_string_from_system(),_message])

## This function logs an error condition that a log inspection should treat with special care. This function will
## not stop the program execution.
func error(_message: String) -> void:
	log_message(Message.new(Logger.Level.ERROR, Time.get_unix_time_from_system(), _message))
	printerr("%s\tERROR\t%s"%[Time.get_datetime_string_from_system(), _message])

## Helper function to retrieve the autoloaded Logger service. If the requester is not in a tree this function
## will return null.
static func get_service(requester: Node) -> Logger:
	var tree: SceneTree = requester.get_tree()
	if tree == null:
		return null
	var root: Node = tree.get_root()
	if root == null:
		return null
	return root.get_node(AUTOLOAD_NAME)

## Level contains the valid log levels.
enum Level {
	ERROR,
	WARNING,
	INFO,
	DEBUG
}

## Message is the data structure in which log messages are stored.
class Message:
	var level: Logger.Level
	var time: float
	var message: String

	func _init(_level: Logger.Level, _time: float, _message: String) -> void:
		level = _level
		time = _time
		message = _message
