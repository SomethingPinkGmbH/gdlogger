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
	log_message(Message.new(Logger.Level.DEBUG, _name, Time.get_unix_time_from_system(), _message))
	print_verbose("%s\tDEBUG\t%s\t%s"%[Time.get_datetime_string_from_system(), _name, _message])

## This function logs informational, but still important messages.
func info(_message: String) -> void:
	log_message(Message.new(Logger.Level.INFO, _name, Time.get_unix_time_from_system(), _message))
	print("%s\tINFO\t%s\t%s"%[Time.get_datetime_string_from_system(), _name, _message])

## This function logs warning messages that convey a potentially problematic information.
func warning(_message: String) -> void:
	log_message(Message.new(Logger.Level.WARNING, _name, Time.get_unix_time_from_system(), _message))
	printerr("%s\tWARNING\t%s\t%s"%[Time.get_datetime_string_from_system(), _name, _message])

## This function logs an error condition that a log inspection should treat with special care. This function will
## not stop the program execution.
func error(_message: String) -> void:
	log_message(Message.new(Logger.Level.ERROR, _name, Time.get_unix_time_from_system(), _message))
	printerr("%s\tERROR\t%s\t%s"%[Time.get_datetime_string_from_system(), _name, _message])

## This function returns the root logger.
func get_root_logger() -> Logger:
	var tree: SceneTree
	if _owner != null:
		tree = _owner.get_tree()
	else:
		tree = get_tree()
	if tree == null:
		return null
	var root: Node = tree.get_root()
	if root == null:
		return null
	return root.get_node(AUTOLOAD_NAME)

## Create a child logger for a specific 
func create_child(requester: Node) -> Logger:
	var child_logger: Logger = Logger.new()
	child_logger._name = Class.get_object_class_name(requester)
	child_logger._owner = requester
	
	var err = child_logger.message_received.connect(log_message)
	if err != OK:
		error("Failed to connect child logger (%d)"%[err])
	_owner = requester
	requester.tree_entered.connect(child_logger._add_to_tree)
	requester.tree_exited.connect(child_logger._remove_from_tree)
	
	var root := child_logger.get_root_logger()
	if root != null:
		root.add_child(child_logger)
	
	return child_logger

## Stores the name of the logger.
var _name: String = ""
## Owning node of the current logger.
var _owner: Node = null

## Adds the current logger to the tree if the owner enters it.
func _add_to_tree():
	get_root_logger().add_child(self)

## Removes the logger from the tree.
func _remove_from_tree():
	var parent = get_parent()
	if parent != null:
		parent.remove_child(self)

## Helper function to retrieve the autoloaded Logger service. If the requester is not in a tree this function
## will return null.
static func get_service(requester: Node) -> Logger:
	var tree: SceneTree = requester.get_tree()
	if tree == null:
		return null
	var root: Node = tree.get_root()
	if root == null:
		return null
	var root_logger: Logger = root.get_node(AUTOLOAD_NAME)
	return root_logger.create_child(requester)

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
	var logger_name: String
	var time: float
	var message: String

	func _init(_level: Logger.Level, _logger_name: String, _time: float, _message: String) -> void:
		level = _level
		logger_name = _logger_name
		time = _time
		message = _message
