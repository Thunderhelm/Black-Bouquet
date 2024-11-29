class_name BrewMeta
extends BrewComponent


signal load_complete()
signal load_failed(err: LOAD_ERR)
signal requirement_requested(requirement_path: String)


enum LOAD_ERR {DIR_MISSING, META_MISSING}


const META_FILE_NAME: String = "brew.bbmeta"
const DESCRIPTION_DEFINITION: String = "describe"


var description: String = "No description provided."



func load_directory(dir_path: String) -> void:
	if not DirAccess.dir_exists_absolute(dir_path):
		load_failed.emit(LOAD_ERR.DIR_MISSING)
		return
	
	var meta_path: String = dir_path + "/" + META_FILE_NAME
	if not FileAccess.file_exists(meta_path):
		load_failed.emit(LOAD_ERR.META_MISSING)
		return
	
	var meta_file: FileAccess = FileAccess.open(meta_path, FileAccess.READ)
	var meta_definitions = string_to_definitions(meta_file.get_as_text())
	if "description" in meta_definitions.keys():
		description = str(meta_definitions["description"])


func to_definition_string() -> String:
	var def_str: String = ""
	
	def_str = def_str + "Reference as " + reference
	def_str = def_str + "\nDisplay as " + display_name
	def_str = def_str + "\n"
	for credit in credits:
		def_str = def_str + "\nCredit as " + credit
	def_str = def_str + "\n\nDescribe as " + description
	
	return def_str
