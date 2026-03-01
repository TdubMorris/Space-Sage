extends Node

signal raceEnd

var current_id : String

var _timerRunning : bool = false
var currentTimeSeconds : float = 0
var maxLaps : int = 3
var currentLap : int = 0
var raceEnded : bool = false

var boost_charge_time : float = 0.75
var boost_charge : float = 0


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
	raceEnded = true

func reset():
	raceEnded = false
	currentTimeSeconds = 0
	_timerRunning = false
	currentLap = 0

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _process(delta : float) -> void:
	if _timerRunning:
		currentTimeSeconds += delta

func lap():
	if currentLap == maxLaps and not raceEnded:
		raceEnd.emit()
		stop()
		return
	currentLap += 1
