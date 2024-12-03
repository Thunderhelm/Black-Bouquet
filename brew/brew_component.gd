class_name BrewComponent
extends Node


const OPTIONAL_DECLARATION_BY: String = "By"
const OPTIONAL_DECLARATION_IS: String = "Is"


var display: String = "":
	get:
		if display == "":
			return name
		else:
			return display



func validate_config(conf_content: String) -> bool:
	print(conf_content)
	var lines: PackedStringArray = conf_content.split("\n")
	if not conf_content.begins_with("#"):
		return false # Does not start with resource name.
	if lines[0].count("\"") > 2 or lines[0].count("\"") == 1:
		return false # Does not have complete display name declaration
	return _validate(lines)

func _validate(lines: PackedStringArray) -> bool:
	return false


static func from_file(file_path: String) -> BrewComponent:
	return
