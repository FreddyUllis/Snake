@tool
extends EditorPlugin


var dialog: AcceptDialog
var button: Button
var font: Font
var theme: Theme
var constants: Script = load("res://addons/create_comment/Scripts/constants.gd")


func _enter_tree() -> void:
	print(constants.PLUGIN_ON)
	
	font = load(constants.FONT_BUTTON)
	
	if font:
		print(constants.FONT_SUCCESS)
	else:
		print(constants.FONT_ERROR)
	
	theme = Theme.new()
	theme.set_font("font", "Button", font)
	
	button = Button.new()
	button.theme = theme
	button.text = constants.CREATE_COMMENT
	
	add_control_to_container(CONTAINER_TOOLBAR, button)
	
	button.connect("pressed", Callable(self, "_on_button_pressed"))


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	print(constants.PLUGIN_OFF)


func _on_button_pressed() -> void:
	var script_editor: ScriptEditorBase = (
		get_editor_interface().get_script_editor().get_current_editor()
	)
	if not script_editor or not script_editor.is_class("ScriptTextEditor"):
		return
	
	var text_edit: TextEdit = script_editor.get_base_editor()
	if not text_edit or not text_edit.is_class("TextEdit"):
		return
	
	var from_line = text_edit.get_selection_from_line()
	var to_line = text_edit.get_selection_to_line()
	
	if from_line == -1 or to_line == -1:
		from_line = text_edit.get_caret_line()
		to_line = from_line
	
	var should_comment = false
	for line in range(from_line, to_line + 1):
		var line_text = text_edit.get_line(line).strip_edges()
		if not line_text.begins_with("#"):
			should_comment = true
			break
	
	for line in range(from_line, to_line + 1):
		var line_text = text_edit.get_line(line)
		if should_comment:
			text_edit.set_line(line, "# " + line_text)
		else:
			if line_text.begins_with("#"):
				
				var comment_index = line_text.find("#")
				if comment_index != -1:
					var new_line = line_text.substr(0, comment_index) + line_text.substr(comment_index + 1).lstrip(" ")
					text_edit.set_line(line, new_line)
