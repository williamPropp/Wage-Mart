extends Control

onready var grid = get_node("GridContainer")
var index = 0
var labels = ["Pay", "Tax Withheld", "Rent", "Food", "Gas", "Health Insurance", "Car Insurance", "Savings"]
var price = ["+$420", "-$43", "-$980", "-$190", "-$90", "-$400", "-$130", "+$1080"]
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("left_mouse"):
		if(index < labels.size()):
			add_label(labels[index], "right")
			add_label("spacing")
			add_label(price[index], "left")
			index += 1

func add_label(new_text, align = "center"):
	var new_label = Label.new()
	grid.add_child(new_label)
	new_label.text = new_text
	match (align):
		"left":
			new_label.align = Label.ALIGN_LEFT
		"right":
			new_label.align = Label.ALIGN_RIGHT
		"center":
			new_label.align = Label.ALIGN_CENTER
	
	if(new_label.text == "spacing"):
		new_label.add_color_override("font_color", Color(1,1,1,0))
