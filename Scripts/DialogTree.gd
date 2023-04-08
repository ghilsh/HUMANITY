extends Node

var queue: Array
var queue_append: Array
var death_count: int

func _ready():
	add_to_group("dialogtree")

func _process(_delta):
	death_count = Global.death_count

func get_dialog(dialog: String, talkedto: int):
	queue.clear()
	queue_append.clear()
	match dialog:
		"intro": # ROOM 2
			if Global.triggered_cutscene == false:
				queue = [
					"Welcome back.",
					"Regardless of your previous performance, I want you to think of this as a fresh start.",
					"It will be tough, but this is well within your capabilities.",
					"You may find various denizens that look like me scattered across the terrian. Talk to them using [Z].",
					"We will be there to guide you through this world's numerous challenges, and provide insight on your performance.",
					"I shan’t hold you up any longer, be on your way now."] 
				Global.triggered_cutscene = true
			else: 
				queue = ["Be on your way now."]
		"bullets": # ROOM 4
			if talkedto == 0:
				queue = [ 
					"The projectiles impede your path.",
					"They may seem as if they serve to make your journey more difficult...",
					"...But perhaps they provide you with the strength you need to overcome your internal matters."]
			queue_append = ["Suppose the choice is yours."]
		"deaths": # ROOM 7
			if death_count == 1:
				queue = ["It would seem that you have sustained 1 death."]
			else: queue = ["It would seem that you have sustained " + String(death_count) + " deaths."]
			if death_count == 0:
				queue_append = [
					"You are beginning to master the traversal of this land.",
					"Certainly a feat worth celebrating, but I implore you to keep your wits about you.",
					"Your journey is far from over..."]
			elif death_count < 10:
				queue_append = [
					"You have greatly improved, however you have yet to reach perfection.",
					"I implore you to keep going, for you are remarkably close.",
					"You have proven to be more then capable of braving the challenges this world has laid out for you."]
			elif death_count >= 10 && death_count <= 150:
				queue_append = [
					"I understand that this may be daunting, but it is of utmost importance that you march on.",
					"Once you have once again braved this world's many challenges, you can always return for a more favourable result.",
					"Once this opportunity arrives, I advise that you take it."]
			else:
				queue_append = [
					"Jesus christ dude.",
					"Look I try to keep things formal but that's fuckin' EMBARRASSING.",
					"You doin' this shit on purpose??? I'd fuckin' HOPE YOU ARE.",
					"Get outta here, kid."
				]
		"patience": # ROOM 9
			queue = [
				"It may be tempting to run head-first into the fray...",
				"...However, it would be beneficial to wait for the right time to strike.",
				"Wait for the exact moment that the bullet passes your corporeal form, and make your move."
			]
		"lastroom": # ROOM 11
			queue = [
				"You have reached the final test of this journey.",
				"Think of it as the culmination of every challenge you've faced thus far.",
				"I wish you the best of luck."
				]
			if death_count <= 5:
				queue_append = ["...Not that you need it, of course."]
		"final": # ROOM 13
			if death_count == 0:
				queue = [
					"So it appears that you have achieved complete and utter perfection.",
					"It is time to close the book on this journey, and start looking towards what comes next.",
					"The lessons you've learned on this adventure are truly invaluable.",
					"And for what it's worth...",
					"...We've truly enjoyed observing your journey."
					]
			elif death_count == 1:
				queue = [
					"Damn... looks like you only died once.",
					"Well, that's a bit annoying. Seems like you were rather close.",
					"I'm honestly tempted to show you the true ending regardless...",
					"Hmmmm...",
					"...",
					"...",
					"...Nah."
					]
			else:
				queue = [
					"So it appears that you have conquered the final challenge.",
					"And in "+String(Global.death_count)+" deaths, no less."
					]
				if death_count <= 15:
					queue_append = [
						"Mistakes were certainly made, but you are on the right track.",
						"Everytime you return to this world, your mastery of it increases.",
						"At this rate, it won't be long before you achieve perfection.",
						"Don't give up on this world."
					]
				else:
					queue_append = [
						"These numbers are far from perfection, but this needn't be the end.",
						"You have the power to return to this world... with a fresh perspective.",
						"From here, you can brave this world's many challenges once again...",
						"...And perhaps return for a more favourable result.",
						"It will be tough, but this is well within your capabilities.",
						"Be on your way now."
					]
		"ending": # ROOM END
			if death_count == 0:
				queue = [
					"Looks like you reached the end.",
					"This quest has been long fought; you've partaken this journey many times before...",
					"...And yet you can't shake the feeling that this one was a turning point.",
					"Mind racing, you close your eyes..."
				]
			else:
				if death_count <= 15:
					queue = [
						"You've reached an end to your journey.",
						"Gruelling as this world's challenges may be, you feel a growing familiarity with its rules and layout.",
						"The apprehension you've once felt has greatly diminished... and yet certainly still present.",
						"You attempt to collect your thoughts and steady your breath."
					]
				else:
					queue = [
						"You've reached an end to your journey.",
						"This trek was long and arduous, and yet you've found yourself on the other side.",
						"Still, you ponder the strange figure's words... could you really partake on this journey once again?",
						"And furthermore... would you even want to?",
						"You hollow your lungs, and attempt to shift your focus to anything other then your pounding headache."
					]
				queue_append = [
					"Mind racing, you close your eyes...",
					"...And wake up in a dark room."
					]
		"trueending":
			queue = [
				"...And take a deep breath.",
				"You feel the light breeze of the wind brush across your face.",
				"A warm glow smothers your cheek... the sun is rising.",
				"Sensations like these seemed so distant in those dark, winding caverns you found yourself in.",
				"But... now you ponder if you've perhaps found yourself somewhere new.",
				"Yes, this is most certainly somewhere new.",
				"Suddenly, you get a sinking feeling in your stomach, but you try to remain optimistic.",
				"With some apprehension, you open your eyes...",
				"...and marvel at how beautiful the world surrounding you is."
			]
		"weird": # ROOM 3
			queue = [
				"heheheeheeeheeahah",
				"hey kid check thisz out.,.,.,,",
				"*audibly shits pants* awwwww yeeaaaaa thats the good stuf brotha"
			]
		"cool": # ROOM 8
			queue = [
				"Yeeeaah...",
				"I'm, like, the cool one."
			]
		"placeholder": # DEFAULT TEXT
			queue = ["OOPSIE: DIALOG MISSING! SILLY PROGRAMMER!!!"]
	
	for x in queue_append:
		queue.append(x)
	for x in queue:
		Global.Textbox.queue_text(x)
	
	get_tree().call_group("npc", "dialog_status")
	get_tree().call_group("end", "dialog_status")
