extends Node


static func parse(file: FileAccess) -> Dictionary:
	var to_parse: String = file.get_as_text()
	var return_dict: Dictionary = {}
	var levels: Array[Dictionary] = []
	for line in to_parse.split("\n"):
		var key: String = line.split(":")[0].strip_edges()
		var value: String = line.split(":")[1].strip_edges()
		var current_level: int = line.split("key")[0].length() / 2
	return return_dict
