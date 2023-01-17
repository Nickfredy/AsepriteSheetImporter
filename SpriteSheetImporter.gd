extends Node
##################
# SIGNALS
##################
##################
# CONSTANTS
##################
#------------------
#Mac and use steam:
const mac_w_steam = '~/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/MacOS/aseprite'
#Mac without steam:
const mac = '/Applications/Aseprite.app/Contents/MacOS/aseprite'
#------------------
#Windows with steam
const windows_w_steam = 'C:\\Program Files (x86)\\Steam\\steamapps\\Aseprite\\aseprite.exe'
#Windows without steam
const windows = 'C:\\Program Files\\Aseprite\\aseprite.exe'
var file_separator := '/'
var possible_aseprite_dirs := []
var aseprite_files := []
##################
# VARIABLES
##################
#CHANGE THESE IF YOU WANT
var output_directory := 'res://assets'
var input_directory := 'res://assets'
var scale := 8.0
##################
# ONREADY VARS
##################
##################
# SCENES
##################
##################
# FUNCTIONS
##################
func get_aseprite_dir():
	var os = OS.get_name()
	if os == 'Windows':
		file_separator = '\\'
		possible_aseprite_dirs = [windows_w_steam,windows]
	elif os == 'OSX':
		var output = []
		var res = OS.execute('echo',['$HOME'],true,output)
		if res != 0:
			print("Something went wrong trying to get your OS home directory")
		var mac_steam_dir = mac_w_steam.replace('~',output[0].replace('\n',''))
		file_separator = '/'
		possible_aseprite_dirs = [mac_steam_dir,mac]
		
#----------------------------------
func list_files_in_directory(path:String) -> void:
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with('.aseprite'):
			aseprite_files.append(file)

	dir.list_dir_end()
	
#--------------------------------
func export_files_from_aseprite() -> void:
	for f in aseprite_files:
		for dir in possible_aseprite_dirs:
			var output = []
			var output_file_name = f.replace('.aseprite','.png')
			var output_file = ProjectSettings.globalize_path(output_directory)+file_separator+output_file_name
			var input_file = ProjectSettings.globalize_path(input_directory)+file_separator+f
			var res = OS.execute(
				dir,
				['-b',input_file,'--scale',scale,'--sheet',output_file],
				true,
				output
			)
			if res == 0:
				print("successfully imported " + str(f))
			elif res == 127:
				possible_aseprite_dirs.erase(dir)
	
#--------------------------------			
func import_assets():
	get_aseprite_dir()
	list_files_in_directory(input_directory)
	export_files_from_aseprite()
##################
# _BUILT_IN_FUNCS
##################
func _ready():
	pass

##################
# _FUNCTIONS
##################
##################
# _SIGNAL_FUNCS
##################
