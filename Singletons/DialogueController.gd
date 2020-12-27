extends Node

var messageObj
var messageBox
var prompt

var messages = [
	"What [tornado radius=5 freq=6]country[/tornado] you from!",
	"[shake]What?",
	"'What' ain't no country I know! Do they speak English in 'What'?",
	"[shake]What?",
	"[shake rate=25 level=20]English-motherfucker-can-you-speak-it?",
	"[shake][fade start=0 length=5]Yes...",
	"Then you understand what I'm saying'?",
	"Now describe what Marsellus Wallace looks like!",
	"What?",
	"Say 'What' again! C'mon, say 'What' again! I dare ya, I double dare ya motherfucker, say 'What' one more goddamn time!"
	]
var currentMsg = 0
var showingMessage = false

# Called when the node enters the scene tree for the first time.
func _ready():
	messageObj = get_node("/root/Main/MessageWindow")
	messageBox = messageObj.get_node("MessageBox")
	prompt = messageObj.get_node("InteractPrompt")
	
	hide_message()
	
func show_message():
	if !showingMessage:
		messageBox.visible = true
		update_bbcode(messages[0])
		toggle_prompt(-1)
		showingMessage = true		
	else:
		progress_text()
	
	
func hide_message():
	messageBox.visible = false
	showingMessage = false
	currentMsg = 0

func progress_text():
	currentMsg = currentMsg + 1
	if currentMsg == messages.size():
		hide_message()
		toggle_prompt(1)	
	update_bbcode(messages[currentMsg])

func update_bbcode(msg):
	messageBox.get_node("RichText").bbcode_text = msg

func toggle_prompt(show = 0):
	if show == 0:
		prompt.visible = !prompt.visible
	else:
		prompt.visible = true if show == 1 else false
