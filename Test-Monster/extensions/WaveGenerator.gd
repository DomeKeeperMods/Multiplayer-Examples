extends "res://content/monster/WaveGenerator.gd"

func _ready():
	super()
	var snippet = WaveSnippet.new()
	snippet.teamId = teamId
	snippet.addEntry(WaveEntry.new("add.newmonster.left"))
	snippet.addEntry(WaveEntry.new("wait.2"))
	allSnippets.append(snippet)
