extends Node


const GODOTMODDING_EXAMPLEMOD_DIR := "Test-Monster"
const GODOTMODDING_EXAMPLEMOD_LOG_NAME := "Test-Monster:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(GODOTMODDING_EXAMPLEMOD_DIR)
	install_script_extensions()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("WaveGenerator.gd"))

func _ready() -> void:
	ModLoaderLog.info("Ready!", GODOTMODDING_EXAMPLEMOD_LOG_NAME)
	MonsterSynchronizer.register_monster("newmonster", load(mod_dir_path.path_join("TestMonster.tscn")), load(mod_dir_path.path_join("TestMonster.gd")))
	await Data.ready
	add_monster_properties()
	update_monster_worlds()
	
func add_monster_properties():
	Data.gameProperties["newmonster.weight"] = 10
	Data.gameProperties["newmonster.tier"] = 1
	Data.gameProperties["newmonster.size"] = "medium"
	Data.gameProperties["newmonster.health"] = 40
	Data.gameProperties["newmonster.fullstunthreshold"] = 1.0
	Data.gameProperties["newmonster.stunpriority"] = 2
	Data.gameProperties["newmonster.variants"] = ["left", "right"]
	Data.gameProperties["newmonster.minrunweight"] = 0
	Data.gameProperties["newmonster.repeatable"] = true
	
func update_monster_worlds():
	Data.gameProperties["monstersbyworld.world1"] = ["newmonster"]
	Data.gameProperties["monstersbyworld.world2"] = ["newmonster"]
	Data.gameProperties["monstersbyworld.world3"] = ["newmonster"]
	Data.gameProperties["monstersbyworld.world4"] = ["newmonster"]
	Data.gameProperties["monstersbyworld.world5"] = ["newmonster"]
	Data.gameProperties["monstersbyworld.world6"] = ["newmonster"]
	Data.gameProperties["monstersbyworld.world7"] = ["newmonster"]
