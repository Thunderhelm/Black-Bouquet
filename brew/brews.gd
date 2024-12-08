extends Node

const BUILT_IN_PATH: String = "res://brew/built-in"
const META_FILE_NAME: String = "brew.bbmeta"


var brew_paths: Array[String] = [
	"user://brew"
]
var brew_file_extensions: Dictionary = {
	("." + META_FILE_NAME.split(".")[-1]): BrewMeta
}



func _ready() -> void:
	rebuild_brews()


func rebuild_brews() -> void:
	var brew_roots: Array[String] = [BUILT_IN_PATH]
	for path in brew_paths:
		var dirs: PackedStringArray = DirAccess.get_directories_at(path)
		var path_roots: Array[String] = []
		for dir in dirs:
			if not validate_brew_root(path + "/" + dir): continue
			brew_roots.append(path + "/" + dir)
	
	var threads: Array[Thread] = []
	for root in brew_roots:
		var thread: Thread = Thread.new()
		thread.start(build_brew.bind(root))
		threads.append(thread)
	for thread in threads:
		var brew_root: BrewMeta = thread.wait_to_finish()
		add_child(brew_root)


func validate_brew_root(root: String) -> bool:
	var meta_file_path: String = root + "/" + META_FILE_NAME
	if not FileAccess.file_exists(meta_file_path):
		return false
	var meta_file: FileAccess = FileAccess.open(meta_file_path, FileAccess.READ)
	var meta_content: String = meta_file.get_as_text()
	meta_file.close()
	var meta: BrewMeta = BrewMeta.new()
	var result: bool = meta.validate_config(meta_content)
	meta.queue_free()
	return result



func build_brew(brew_root_path: String) -> BrewMeta:
	var brew_root: BrewMeta = BrewMeta.from_file(brew_root_path + "/" + META_FILE_NAME)
	print(brew_root)
	return brew_root


func get_component(caller_namespace: BrewMeta, component_path: String, hint: BrewComponent.TYPES = BrewComponent.TYPES.BLANK) -> BrewComponent:
	var target_namespace: BrewMeta
	if component_path.begins_with("#"):
		target_namespace = caller_namespace
		component_path = component_path.replace("#>", "")
	else:
		target_namespace = get_node_or_null(component_path.split(">")[0])
		if not target_namespace:
			return
		component_path = component_path.replace(target_namespace.name + ">", "")
	
	if component_path.begins_with("[]"):
		for component in target_namespace.components:
			if not component.type == hint:
				continue
			if component.name == component_path.split(">")[-1]:
				return component
		return
	
	var found_component: BrewComponent = target_namespace.get_node_or_null(component_path.replace(">", "/"))
	if found_component and (hint == BrewComponent.TYPES.BLANK or hint == found_component.type):
		return found_component
	return
