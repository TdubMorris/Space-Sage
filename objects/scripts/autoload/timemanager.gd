extends Node

signal raceEnd

var _timerRunning : bool = false
var currentTimeSeconds : float = 0
var maxLaps : int = 3
var currentLap : int = 0

func getTimeLabel() -> String:
	var minutes : int = floori(currentTimeSeconds/60)
	var seconds : float = wrap(currentTimeSeconds, 0, 60)
	return "%d:%06.3f" % [minutes, seconds]

func getLapLabel() -> String:
	return "LAP %d/%d" % [currentLap, maxLaps]

func start():
	_timerRunning = true

func stop():
	_timerRunning = false

func reset():
	currentTimeSeconds = 0

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _process(delta : float) -> void:
	if _timerRunning:
		currentTimeSeconds += delta

func lap():
	if currentLap == maxLaps:
		raceEnd.emit()
		stop()
		return
	currentLap += 1
