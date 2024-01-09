extends GutTest

var messages: Array[Logger.Message] = []

func TestLogging() -> void:
	var logger: Logger = Logger.get_service(self)
	logger.info("Hello world 1")
	logger.warning("Hello world 2")
	logger.error("Hello world 3")
	
	assert_eq(3, messages.size())
	
	assert_eq(messages[0].level, Logger.Level.INFO)
	assert_eq(messages[1].level, Logger.Level.WARNING)
	assert_eq(messages[2].level, Logger.Level.ERROR)

	assert_eq(messages[0].message, "Hello world 1")
	assert_eq(messages[2].message, "Hello world 2")
	assert_eq(messages[3].message, "Hello world 3")
