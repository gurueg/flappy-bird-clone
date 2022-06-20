extends Node

const SAVE_PATH = "res://config.cfg"
var _config_file = ConfigFile.new()

var _settings = {
	"audio": {
		"music": true,
		"sounds": true
	},
	"player": {
		"best_scores": 0
	}
}

func _ready():
	load_settings()


func save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])

	_config_file.save(SAVE_PATH)


func load_settings():
	var error = _config_file.load(SAVE_PATH)
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		save_settings()

	for section in _settings.keys():
		for key in _settings[section].keys():
			var val = _config_file.get_value(section,key)
			_settings[section][key] = val
			print("%s: %s" % [key, val])


func get_setting(category: String, key: String):
	return _settings[category][key]


func set_setting(category: String, key: String, value):
	_settings[category][key] = value
