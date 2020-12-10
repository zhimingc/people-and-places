extends Node

var messageObj
var messageBox
var prompt

var messages = [
	"What country you from!",
	"What?",
	"'What' ain't no country I know! Do they speak English in 'What'?",
	"What?",
	"English-motherfucker-can-you-speak-it?",
	"Yes.",
	"Then you understand what I'm saying'?",
	"Now describe what Marsellus Wallace looks like!",
	"What?",
	"Say 'What' again! C'mon, say 'What' again! I dare ya, I double dare ya motherfucker, say 'What' one more goddamn time!"
	]
var currentMsg = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	messageObj = get_node("/root/Main/MessageWindow")
	messageBox = messageObj.get_node("MessageBox")
	prompt = messageObj.get_node("InteractPrompt")
	
	hide_message()
	
func show_message():
	messageBox.visible = true
	toggle_prompt(-1)
	
func hide_message():
	messageBox.visible = false
	toggle_prompt(1)

func toggle_prompt(show = 0):
	if show == 0:
		prompt.visible = !prompt.visible
	else:
		prompt.visible = true if show == 1 else false
