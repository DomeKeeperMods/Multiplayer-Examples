extends Node

const MOD_DIR := "Graciano-Keeper5Spike"
const LOG_NAME := "Graciano-Keeper5Spike:Main"

var mod_dir_path := ""


func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)


func _ready() -> void:
	add_to_group("mod_init")
	ModLoaderLog.info("Ready", LOG_NAME)


func modInit() -> void:
	Data.parseUpgradesYaml(mod_dir_path.path_join("yaml/upgrades.yaml"))

	Keepers.register_keeper(
		"keeper5",
		load("res://content/keeper/keeper1/spriteframes-skin0-color0.tres"),
		load("res://content/icons/loadout_keeper1-skin0.png"),
	)

	ModLoaderLog.info("keeper5 injected. loadoutKeepers=%s" % str(Data.loadoutKeepers), LOG_NAME)
