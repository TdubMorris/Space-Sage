extends Control

@onready var timer_label = %TimerLabel
@onready var lap_label = %LapLabel

# Called every frame. 'ddelta' is the elapsed time since the previous frame.
func _process(_delta):
	timer_label.text = RaceManager.getTimeLabel()
	lap_label.text = RaceManager.getLapLabel()
