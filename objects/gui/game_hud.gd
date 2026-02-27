extends Control

@onready var timer_label = %TimerLabel
@onready var lap_label = %LapLabel

@export var boost_frames : SpriteFrames
@export var curve : Curve

var time_elapse = 0

# Called every frame. 'ddelta' is the elapsed time since the previous frame.
func _process(delta):
	timer_label.text = RaceManager.getTimeLabel()
	lap_label.text = RaceManager.getLapLabel()
	if RaceManager.boost_charge < RaceManager.boost_charge_time and RaceManager.boost_charge > 0:
		%Boostbar.show()
		%Boostbar.texture = boost_frames.get_frame_texture("fill", floori((29/RaceManager.boost_charge_time) * curve.sample(RaceManager.boost_charge/RaceManager.boost_charge_time)))
	elif RaceManager.boost_charge == RaceManager.boost_charge_time:
		time_elapse = wrap(time_elapse + delta, 0, 0.1)
		%Boostbar.texture = boost_frames.get_frame_texture("blink", floori(20 * time_elapse))
	else: %Boostbar.hide()
