extends Node

enum states {HOUSE, MINIGAME, OVERVIEW, TIMER}
var curstate

var overviewON = false

#Ui vars
onready var KScLabel = $OVERview/Control/UImain/InventoryUI/CandyRowA/KSCandyBox/CandyAMT
onready var CANcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowA/CCandyBox/CandyAMT
onready var TBcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowA/TBCandyBox/CandyAMT

onready var SScLabel = $OVERview/Control/UImain/InventoryUI/CandyRowB/SSCandyBox/CandyAMT
onready var CHcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowB/CHCandyBox/CandyAMT
onready var CAcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowB/CACandyBox/CandyAMT

onready var WAcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowC/WACandyBox/CandyAMT
onready var VEcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowC/VECandyBox/CandyAMT
onready var FRcLabel = $OVERview/Control/UImain/InventoryUI/CandyRowC/FRCandyBox/CandyAMT

onready var avpts = $OVERview/Control/UImain/AttsUI/ptscounter

onready var spdc = $OVERview/Control/UImain/AttsUI/SPD/Label
onready var chac = $OVERview/Control/UImain/AttsUI/CHA/Label
onready var sklc = $OVERview/Control/UImain/AttsUI/SKL/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	curstate = states.OVERVIEW
	runOverview()

func _process(delta):
	if curstate != states.OVERVIEW:
		pass

func changestate():
	if curstate == states.OVERVIEW:
		curstate = states.TIMER
		runTimer()
	pass

func runTimer():
	pass

func runOverview():
	var tween = $OVERview/Tween
	$OVERview/Control/prompt.modulate = Color(1,1,1,0)
	$OVERview/Control/UImain.rect_position.y = -300
	$OVERview/Control/nexthouse.rect_position.y = 900
	
	tween.interpolate_property($OVERview/Control/UImain, "rect_position:y", $OVERview/Control/UImain.rect_position.y, 120, 1,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.interpolate_property($OVERview/Control/prompt, "modulate", $OVERview/Control/prompt.modulate, Color(1,1,1,1), 1,Tween.TRANS_CIRC,Tween.EASE_IN_OUT,0.5)
	tween.interpolate_property($OVERview/Control/nexthouse, "rect_position:y", $OVERview/Control/nexthouse.rect_position.y, 576, 1,Tween.TRANS_CIRC,Tween.EASE_OUT,1)
	tween.start()
	
	#inventory set
	KScLabel.bbcode_text = str("[center][wave]", $PlayerStats.kingsize)
	CANcLabel.bbcode_text = str("[center][wave]", $PlayerStats.cans)
	TBcLabel.bbcode_text = str("[center][wave]", $PlayerStats.treatbags)
	
	SScLabel.bbcode_text = str("[center][wave]", $PlayerStats.snacksize)
	CHcLabel.bbcode_text = str("[center][wave]", $PlayerStats.chips)
	CAcLabel.bbcode_text = str("[center][wave]", $PlayerStats.candies)
	
	WAcLabel.bbcode_text = str("[center][wave]", $PlayerStats.water)
	VEcLabel.bbcode_text = str("[center][wave]", $PlayerStats.veggies)
	FRcLabel.bbcode_text = str("[center][wave]", $PlayerStats.fruit)
	
	#attribute set
	avpts.bbcode_text = str("pts: [rainbow freq=0.3 sat=10 val=20]", $PlayerStats.apoints)
	spdc.bbcode_text = str("spd: ", $PlayerStats.speed, "/10")
	chac.bbcode_text = str("cha: ", $PlayerStats.charm, "/10")
	sklc.bbcode_text = str("skl: ", $PlayerStats.skill, "/10")
	
	overviewON = true


func _on_PlayerStats_sklchange():
	avpts.bbcode_text = str("pts: [rainbow freq=0.3 sat=10 val=20]", $PlayerStats.apoints)
	sklc.bbcode_text = str("skl: ", $PlayerStats.skill, "/10")


func _on_PlayerStats_chachange():
	avpts.bbcode_text = str("pts: [rainbow freq=0.3 sat=10 val=20]", $PlayerStats.apoints)
	chac.bbcode_text = str("cha: ", $PlayerStats.charm, "/10")


func _on_PlayerStats_spdchange():
	avpts.bbcode_text = str("pts: [rainbow freq=0.3 sat=10 val=20]", $PlayerStats.apoints)
	spdc.bbcode_text = str("spd: ", $PlayerStats.speed, "/10")


func _on_PlayerStats_changefail():
	avpts.bbcode_text = str("[shake rate=60 level=40]pts: [rainbow freq=0.3 sat=10 val=20]", $PlayerStats.apoints)
	yield(get_tree().create_timer(.5), "timeout")
	avpts.bbcode_text = str("pts: [rainbow freq=0.3 sat=10 val=20]", $PlayerStats.apoints)


func _on_nexthouse_pressed():
	changestate()
