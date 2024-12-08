class_name BrewMeta
extends BrewComponent
func _get_type() -> TYPES:
	return TYPES.META


const REQUIRED_DECLARATION_EDITION: String = "Edition"
const REQUIRED_DECLARATION_VERSION: String = "Version"


var components: Array[BrewComponent] = []



func _validate(lines: PackedStringArray) -> bool:
	if not lines[0].begins_with("#="):
		return false # Not declaring root namespace, likely typo.
	if lines[0].contains(">") or lines[0].contains("[]"):
		return false # Using implied or non-root namespace
	var valid_edition: bool = false
	var valid_version: bool = false
	
	for line in lines:
		if line == lines[0]:
			continue
		if not line.contains(":"):
			continue
		if not line.split(":")[1].strip_edges().is_valid_int():
			continue
		
		if not valid_edition:
			valid_edition = line.begins_with(REQUIRED_DECLARATION_EDITION)
		if not valid_version:
			valid_version = line.begins_with(REQUIRED_DECLARATION_VERSION)
	
	if not (valid_version and valid_edition):
		return false
	return true


static func from_file(file_path: String) -> BrewMeta:
	print(file_path)
	var new_meta: BrewMeta = BrewMeta.new()
	var meta_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var meta_content: String = meta_file.get_as_text()
	meta_file.close()
	
	if not new_meta.validate_config(meta_content):
		return
	
	var lines: PackedStringArray = meta_content.split("\n")
	new_meta.name = lines[0].split("#=")[1].split(" ")[0]
	new_meta.brew_namespace = new_meta
	if lines[0].contains("\""):
		new_meta.display = lines[0].split("\"")[1]
	
	return new_meta
