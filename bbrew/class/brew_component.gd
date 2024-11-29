class_name BrewComponent
extends Node


signal reference_updated(new_reference: String)
signal display_name_updated(new_display_name: String)
signal credits_updated(new_credits: Array[String])


const STRING_DEFINE_OPERATOR: String = " as "
const REFERENCE_DEFINITION: String = "reference"
const DISPLAY_DEFINITION: String = "display"
const CREDIT_DEFINITION: String = "credit"


var reference: String:
	set(new_ref):
		reference = new_ref
		reference_updated.emit(new_ref)
var display_name: String:
	get:
		if display_name:
			return display_name
		else:
			return reference
	set(new_name):
		display_name = new_name
		display_name_updated.emit(new_name)
var credits: Array[String]:
	get:
		if credits:
			return credits
		else:
			return ["Anonymous"]
	set(new_cred):
		credits = new_cred
		credits_updated.emit(new_cred)



func string_to_definitions(str: String) -> Dictionary:
	var dict: Dictionary = {}
	for line in str.split("\n"):
		if not str.contains(STRING_DEFINE_OPERATOR):
			continue
		var key: String = line.split(STRING_DEFINE_OPERATOR)[0]
		var val: Variant = line.split(STRING_DEFINE_OPERATOR)[1]
		
		# verification, normalizing, and cleaning for consistancy
		key = key.strip_edges()
		val = val.strip_edges()
		
		key = key.to_lower()
		if val.is_valid_int():
			val = int(val)
		if val.is_valid_float():
			val = float(val)
		
		if key == REFERENCE_DEFINITION:
			reference = val
			continue
		if key == DISPLAY_DEFINITION:
			display_name = val
			continue
		if key == CREDIT_DEFINITION:
			if credits == ["Anonymous"]:
				credits = []
			credits.append(val)
			continue
		dict[key] = val
	
	return dict


func to_definition_string() -> String:
	push_error("Brew component class defined at " + get_script().get_path() + " does not define a definition string.")
	return ""
