extends Node

enum states {HOUSE, MINIGAME, OVERVIEW, TIMER, END}
var curstate

var overviewON = false
var minigameON = false
var m = 0

#Overview UI vars
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

#Timer UI var
onready var timelabel = $Timer/UIlabels/TimeLabel

#mg preloads
const poKS = preload("res://candyphysobj/kingsize.tscn")
const poCAN = preload("res://candyphysobj/cans.tscn")
const poTB = preload("res://candyphysobj/treatbags.tscn")

var spawnlist = [poKS, poCAN, poTB]

# Called when the node enters the scene tree for the first time.
func _ready():
	$House.modulate = Color(1,1,1,0)
	curstate = states.OVERVIEW
	runOverview()

func _process(_delta):
	if curstate != states.OVERVIEW && overviewON:
		overviewON = false
		var tweenOV = $OVERview/Tween
		tweenOV.interpolate_property($OVERview/Control/UImain, "rect_position:y", $OVERview/Control/UImain.rect_position.y, -300, 0.5,Tween.TRANS_EXPO,Tween.EASE_IN)
		tweenOV.interpolate_property($OVERview/Control/prompt, "modulate", $OVERview/Control/prompt.modulate, Color(1,1,1,0), 0.5,Tween.TRANS_CIRC,Tween.EASE_IN_OUT,0.25)
		tweenOV.interpolate_property($OVERview/Control/nexthouse, "rect_position:y", $OVERview/Control/nexthouse.rect_position.y, 900, 0.5,Tween.TRANS_CIRC,Tween.EASE_IN,0.5)
		tweenOV.start()
		yield(tweenOV,"tween_all_completed")
		$OVERview.visible = false
	
	if minigameON && curstate == states.MINIGAME:
		if randf() > 0.4:
			var spawn = randi() % 3
			var drop = spawnlist[spawn].instance()
			drop.set_pos($Minigame/emitter.position)
			add_child(drop)
			minigameON = false
			yield(get_tree().create_timer(1),"timeout")
			minigameON = true
			yield(get_tree(),"idle_frame")

func changestate():
	$PlayerStats.clampcandy()
	yield(get_tree(),"idle_frame")
	if curstate == states.OVERVIEW:
		curstate = states.TIMER
		runTimer()
		return
	
	if curstate == states.TIMER:
		curstate = states.HOUSE
		runHouse()
		return
	
	if curstate == states.HOUSE:
		if $HouseOptions.minigame:
			yield(get_tree().create_timer(1),"timeout")
			curstate = states.MINIGAME
			runMinigame()
			return
		
		curstate = states.OVERVIEW
		runOverview()
		return
	
	if curstate == states.MINIGAME:
		curstate = states.OVERVIEW
		yield(get_tree().create_timer(2),"timeout")
		runOverview()
		return

#func changestate2():
#	yield(get_tree(),"idle_frame")
#	if curstate == states.HOUSE:
#		curstate = states.OVERVIEW
#		runOverview()
#		return

func runMinigame():
	var bar = $Minigame/TextureProgress
	bar.value = 100
	m = 0
	$Minigame/multiplier.bbcode_text = str("[center][tornado radius=15 freq=3][font=res://DFSS2.tres]x[/font]",m)
	$Minigame.visible = true
	yield(get_tree().create_timer(1),"timeout")
	#[rainbow freq=1 sat=20 val=20]
	tweenMg()


func tweenMg():
	var tweenMG = $Minigame/TextureProgress/Tween
	var bar = $Minigame/TextureProgress
	minigameON = true
	tweenMG.interpolate_property(bar, "value", 100, 0, 7,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,3)
	tweenMG.start()
	yield(tweenMG,"tween_completed")
	minigameON = false
	tweenMG.interpolate_property($Minigame, "modulate", $Minigame.modulate, Color(1,1,1,0),1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tweenMG.start()
	yield(tweenMG,"tween_all_completed")
	
	$PlayerStats.kingsize += $PlayerStats.kingsize*m
	$PlayerStats.cans += $PlayerStats.cans*m
	$PlayerStats.treatbags += $PlayerStats.treatbags*m
	$PlayerStats.snacksize += $PlayerStats.snacksize*m
	$PlayerStats.chips += $PlayerStats.chips*m
	$PlayerStats.candies += $PlayerStats.candies*m
	
	$PlayerStats.apoints += 1
	changestate()
	minigameON = false
	$Minigame.visible = false
	$Minigame.modulate = Color(1,1,1,1)

func runHouse():
	yield(get_tree().create_timer(1),"timeout")
	var cam = $House/Camera2D
	var tweenH = $House/Tween
	var plyr = $House/Player
	var RING = $House/HouseUI/RING
	var NEXT = $House/HouseUI/NEXT
	
	$House/Back/Litwindow.visible = false
	$House.modulate = Color(1,1,1,0)
	cam.current = true
	cam.zoom = Vector2(1.5,1.5)
	cam.offset = Vector2(360,320)
	plyr.position.x = -300
	RING.rect_position.y = 900
	NEXT.rect_position.y = 900
	
	$HouseOptions.generateh()
	$House.visible = true
	
	tweenH.interpolate_property(RING, "rect_position:y", RING.rect_position.y, 542, 1,Tween.TRANS_CIRC,Tween.EASE_OUT,2)
	tweenH.interpolate_property(plyr, "position:x", plyr.position.x, 270, 1.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT,1)
	tweenH.interpolate_property($House, "modulate", $House.modulate, Color(1,1,1,1),0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tweenH.interpolate_property(cam, "zoom", cam.zoom, Vector2(1,1),2,Tween.TRANS_EXPO,Tween.EASE_IN_OUT,0.4)
	tweenH.interpolate_property(cam, "offset", cam.offset, Vector2(360,360),2,Tween.TRANS_EXPO,Tween.EASE_IN_OUT,0.4)
	tweenH.start()

func runTimer():
	yield(get_tree().create_timer(2),"timeout")
	timelabel.bbcode_text = str("[center]", $PlayerStats.timeleft)
	$Timer/clock.rect_rotation = 0
	$Timer.visible = true
	
	yield($PlayerStats.calctimeloss(), "completed")
	yield(get_tree().create_timer(0.8),"timeout")
	
	$Timer/Tween.interpolate_property($Timer/clock,"rect_rotation", $Timer/clock.rect_rotation, -45,0.2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Timer/Tween.start()
	
	timelabel.bbcode_text = str("[center]", $PlayerStats.timeleft)
	
	yield(get_tree().create_timer(2),"timeout")
	$Timer.visible = false
	changestate()


func runOverview():
	var tween = $OVERview/Tween
	$OVERview/Control/prompt.modulate = Color(1,1,1,0)
	$OVERview/Control/UImain.rect_position.y = -300
	$OVERview/Control/nexthouse.rect_position.y = 900
	$OVERview.visible = true
	
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
	#Overview Next House
	changestate()


func _on_RING_pressed():
	$House/HouseUI/RING.visible = false
	$House/HouseUI/NEXT.visible = false
	var haus = $HouseOptions
	
	var roll = randi() % 100
	roll -= $PlayerStats.skill*2
	
	print("roll is: ", roll)
	
	if roll < haus.openchance:
		$House/Back/Litwindow.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		$House/Back/Litwindow.visible = true
		yield(get_tree().create_timer(.2), "timeout")
		$House/Back/Litwindow.visible = false
		yield(get_tree().create_timer(1), "timeout")
		$House/Back/Litwindow.visible = true
		yield(get_tree().create_timer(.2), "timeout")
		$House/Back/Litwindow.visible = false
		yield(get_tree().create_timer(2), "timeout")
		$House/Back/Litwindow.visible = true
		
		var charmheightA = randi() % 6
		var charmheightB = randi() % 9
		
		match haus.candylist[haus.candy1]:
			"kingsize":
				$House/CandySpray/KS.emitting = true
				$PlayerStats.kingsize += randi() % 4 + 1
			"cans":
				$House/CandySpray/CAN.emitting = true
				$PlayerStats.cans += randi() % 3
			"treatbags":
				$House/CandySpray/TB.emitting = true
				$PlayerStats.treatbags += randi() % 4 + 1
			"snacksize":
				$House/CandySpray/SS.emitting = true
				$PlayerStats.snacksize += randi() % 4 + 1
			"chips":
				$House/CandySpray/CH.emitting = true
				$PlayerStats.chips += randi() % 4 + 1
			"candies":
				$House/CandySpray/CAA.emitting = true
				$House/CandySpray/CAB.emitting = true
				$House/CandySpray/CAC.emitting = true
				$PlayerStats.candies += randi() % 4 + 1
			"water":
				$PlayerStats.water += randi() % 3
			"veggies":
				$PlayerStats.veggies += randi() % 4
			"fruit":
				$PlayerStats.fruit += randi() % 4
		
		match haus.candylist[haus.candy2]:
			"kingsize":
				$House/CandySpray/KS.emitting = true
				if $PlayerStats.charm > charmheightA:
					$PlayerStats.kingsize += randi() % 4 + 1
			"cans":
				$House/CandySpray/CAN.emitting = true
				if $PlayerStats.charm > charmheightA:
					$PlayerStats.cans += randi() % 3 + 1
			"treatbags":
				$House/CandySpray/TB.emitting = true
				if $PlayerStats.charm > charmheightA:
					$PlayerStats.treatbags += randi() % 4 + 1
			"snacksize":
				$House/CandySpray/SS.emitting = true
				if $PlayerStats.charm > charmheightA:
					$PlayerStats.snacksize += randi() % 4 + 1
			"chips":
				$House/CandySpray/CH.emitting = true
				if $PlayerStats.charm > charmheightA:
					$PlayerStats.chips += randi() % 4 + 1
			"candies":
				$House/CandySpray/CAA.emitting = true
				$House/CandySpray/CAB.emitting = true
				$House/CandySpray/CAC.emitting = true
				if $PlayerStats.charm > charmheightA:
					$PlayerStats.candies += randi() % 4 + 1
			"water":
				$PlayerStats.water += randi() % 3 + 1
			"veggies":
				$PlayerStats.veggies += randi() % 4 + 1
			"fruit":
				$PlayerStats.fruit += randi() % 4 + 1
		
		match haus.candylist[haus.candy3]:
			"kingsize":
				$House/CandySpray/KS.emitting = true
				if $PlayerStats.charm > charmheightB:
					$PlayerStats.kingsize += randi() % 4 + 1
			"cans":
				$House/CandySpray/CAN.emitting = true
				if $PlayerStats.charm > charmheightB:
					$PlayerStats.cans += randi() % 3 + 1
			"treatbags":
				$House/CandySpray/TB.emitting = true
				if $PlayerStats.charm > charmheightB:
					$PlayerStats.treatbags += randi() % 4 + 1
			"snacksize":
				$House/CandySpray/SS.emitting = true
				if $PlayerStats.charm > charmheightB:
					$PlayerStats.snacksize += randi() % 4 + 1
			"chips":
				$House/CandySpray/CH.emitting = true
				if $PlayerStats.charm > charmheightB:
					$PlayerStats.chips += randi() % 4 + 1
			"candies":
				$House/CandySpray/CAA.emitting = true
				$House/CandySpray/CAB.emitting = true
				$House/CandySpray/CAC.emitting = true
				if $PlayerStats.charm > charmheightB:
					$PlayerStats.candies += randi() % 4 + 1
			"water":
				$PlayerStats.water += randi() % 3 + 1
			"veggies":
				$PlayerStats.veggies += randi() % 4 + 1
			"fruit":
				$PlayerStats.fruit += randi() % 4 + 1
		
		yield(get_tree().create_timer(3), "timeout")
		$House.visible = false
		$House/HouseUI/RING.visible = true
		changestate()
	else:
		$House/Back/Litwindow.visible = false
		yield(get_tree().create_timer(.5), "timeout")
		$House/Back/Litwindow.visible = true
		yield(get_tree().create_timer(.2), "timeout")
		$House/Back/Litwindow.visible = false
		yield(get_tree().create_timer(1), "timeout")
		$House/Back/Litwindow.visible = true
		yield(get_tree().create_timer(.2), "timeout")
		$House/Back/Litwindow.visible = false
		yield(get_tree().create_timer(3), "timeout")
		$House/HouseUI/RING.visible = true
		$House/HouseUI/NEXT.visible = true
		var tweenH = $House/Tween
		var NEXT = $House/HouseUI/NEXT
		if NEXT.rect_position.y > 642:
			tweenH.interpolate_property(NEXT, "rect_position:y", NEXT.rect_position.y, 642, 1,Tween.TRANS_CIRC,Tween.EASE_OUT)
			tweenH.start()
	return


func _on_NEXT_pressed():
	$House.visible = false
	$HouseOptions.minigame = false
	yield(get_tree(),"idle_frame")
	changestate()
	#House next house


func _on_Mgbag_mUP():
	m += 1
	var tweenMUL = $Minigame/multiplier/Tween
	tweenMUL.interpolate_property($Minigame/multiplier, "rect_scale", $Minigame/multiplier.rect_scale, Vector2(1.1, 1.1),0.1,Tween.TRANS_BACK,Tween.EASE_IN)
	tweenMUL.interpolate_property($Minigame/multiplier, "rect_scale", $Minigame/multiplier.rect_scale, Vector2(1, 1),0.3,Tween.TRANS_BACK,Tween.EASE_IN_OUT,0.25)
	tweenMUL.start()
	if m > 5:
		$Minigame/multiplier.bbcode_text = str("[center][tornado radius=15 freq=3][rainbow freq=1 sat=20 val=20][font=res://DFSS2.tres]x[/font]",m)
	else:
		$Minigame/multiplier.bbcode_text = str("[center][tornado radius=15 freq=3][font=res://DFSS2.tres]x[/font]",m)


func _on_killm_body_entered(_body):
	if curstate == states.MINIGAME:
		m -= 5
	var tweenMUL = $Minigame/multiplier/Tween
	tweenMUL.interpolate_property($Minigame/multiplier, "rect_scale", $Minigame/multiplier.rect_scale, Vector2(1.1, 1.1),0.1,Tween.TRANS_BACK,Tween.EASE_IN)
	tweenMUL.interpolate_property($Minigame/multiplier, "rect_scale", $Minigame/multiplier.rect_scale, Vector2(1, 1),0.3,Tween.TRANS_BACK,Tween.EASE_IN_OUT,0.25)
	tweenMUL.start()
	$Minigame/multiplier.bbcode_text = str("[center][tornado radius=15 freq=3][font=res://DFSS2.tres]x[/font]",m)


func _on_PlayerStats_outoftime():
	$GameOver.visible = true
	curstate = states.END
	
	var score
