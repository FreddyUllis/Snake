@tool
extends EditorPlugin

var dialog: AcceptDialog
var button: Button
var font: Font
var theme: Theme
var constants: Script = load("res://addons/FolderCreator/Scripts/constants.gd")

func _enter_tree():
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
	button.text = constants.CREATE_FOLDERS
	
	add_control_to_container(CONTAINER_TOOLBAR, button)
	
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	
func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	print(constants.PLUGIN_OFF)

func _on_button_pressed():

	dialog = AcceptDialog.new()
	dialog.set_size(Vector2i(250, 150))
	dialog.set_title(constants.CREATE_FOLDERS)
	
	
	var vbox = VBoxContainer.new()
	dialog.add_child(vbox)

	var label = Label.new()

	label.text = constants.ENTER_NAME_FOLDER
	vbox.add_child(label)
	
	var line_edit = LineEdit.new()
	vbox.add_child(line_edit)
	
	var checkbox_scenes = CheckBox.new()
	checkbox_scenes.text = constants.FOLDERS["Scenes"]
	vbox.add_child(checkbox_scenes)
	
	var checkbox_scripts = CheckBox.new()
	checkbox_scripts.text = constants.FOLDERS["Scripts"]
	vbox.add_child(checkbox_scripts)
	
	var checkbox_resources = CheckBox.new()
	checkbox_resources.text = constants.FOLDERS["Resources"]
	vbox.add_child(checkbox_resources)
	
	var checkbox_art = CheckBox.new()
	checkbox_art.text = constants.FOLDERS["Art"]
	vbox.add_child(checkbox_art)
	
	var button_create = Button.new()
	button_create.text = constants.CREATE_FOLDERS
	button_create.connect(
		"pressed", Callable(self, "_on_create_pressed").bind(
			line_edit, checkbox_scenes, checkbox_scripts,
			checkbox_resources, checkbox_art
		)
	)
	vbox.add_child(button_create)
	
	add_child(dialog)
	dialog.popup_centered()

func _on_create_pressed(
	line_edit, checkbox_scenes, checkbox_scripts,
	checkbox_resources, checkbox_art
):
	var folder_name = line_edit.text
	if not folder_name:
		print(constants.NAME_ROOT_FOLDER_NOT_SPECIFIED)
		return
	
	var dir = DirAccess.open(constants.DIRECTORIES["Root"])
	if dir:
		if not dir.dir_exists(folder_name):
			dir.make_dir(folder_name)
		else:
			print(constants.NAME_ALREADY_EXISTS)
			return
		
		if checkbox_scenes.button_pressed:
			dir.make_dir(folder_name + constants.DIRECTORIES["Scenes"])
		if checkbox_scripts.button_pressed:
			dir.make_dir(folder_name + constants.DIRECTORIES["Scripts"])
		if checkbox_resources.button_pressed:
			dir.make_dir(folder_name + constants.DIRECTORIES["Resources"])
		if checkbox_art.button_pressed:
			dir.make_dir(folder_name + constants.DIRECTORIES["Art"])
			dir.make_dir(folder_name + constants.DIRECTORIES["ArtFonts"])
			dir.make_dir(folder_name + constants.DIRECTORIES["ArtImages"])
			dir.make_dir(folder_name + constants.DIRECTORIES["ArtSounds"])
		
		get_editor_interface().get_resource_filesystem().scan()
