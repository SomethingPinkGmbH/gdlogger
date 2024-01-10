# Logger for Godot

This library provides a global autoload library to handle different level log messages. This library requires the [gdtype](https://github.com/SomethingPinkGmbH/gdtype) extension.

## Usage

After enabling the editor plugin, you can request a logger from any node and then use it for logging.

```gdscript
extends Node

@onready
var logger: Logger = Logger.get_service(self)

func _ready():
	var adapter_info = OS.get_video_adapter_driver_info()
	logger.info("Game running on %s %s with %s %s"%[OS.get_name(),OS.get_version(),adapter_info[0],adapter_info[1]])
```
