extends Node2D
onready var mash_y = get_node("/root/YM")
onready var dano = get_node("/root/DanGraf")
var Perem = load("res://Переменная.gd")

var dannue = ['2', '3', '4', '5']
var x0 = 0
var Dx = float(dannue[0])
var kol_x = 1000
var uvel_y = 0
var pred_uvel_y = 0

var mass_p = []

func _ready():
	dannue = dano.text.split(' ')
	var par = []
	x0 = float(dannue[0])
	Dx = float(dannue[1])
	for i in range(2,len(dannue)):
		par.append(float(dannue[i]))

#	par = [9.802, 0.01, 0.288, 0.679536]
	uvel_y = float(mash_y.text)
	for i in range(0, len(par)):
		var one = Perem.new()
		mass_p.append(one)
		mass_p[i].znach = par[i]
	
	var c = rfp(0, mass_p, 0)
	print(c, nfp(0, mass_p, 0))
	
	$Y.value = uvel_y
	$"+V".text = str(200/uvel_y)
	$"+V2".text = str(200/uvel_y * 0.75)
	$"+V3".text = str(200/uvel_y * 0.5)
	$"+V4".text = str(200/uvel_y * 0.25)
	$"-V".text = str(-200/uvel_y)
	$"-V2".text = str(-200/uvel_y * 0.75)
	$"-V3".text = str(-200/uvel_y * 0.5)
	$"-V4".text = str(-200/uvel_y * 0.25)
	var pos = 95
	$"+V".rect_position. x = pos
	$"+V2".rect_position. x = pos
	$"+V3".rect_position. x = pos
	$"+V4".rect_position. x = pos
	$"-V".rect_position. x = pos - 5
	$"-V2".rect_position. x = pos - 5
	$"-V3".rect_position. x = pos - 5
	$"-V4".rect_position. x = pos - 5
	
	$"Горизонтальные штрихи/G1".text = str(x0 - Dx * 0.375)
	$"Горизонтальные штрихи/G2".text = str(x0 - Dx * 0.25)
	$"Горизонтальные штрихи/G3".text = str(x0 - Dx * 0.125)
	$"Горизонтальные штрихи/G4".text = str(x0)
	$"Горизонтальные штрихи/G5".text = str(x0 + Dx * 0.125)
	$"Горизонтальные штрихи/G6".text = str(x0 + Dx * 0.25)
	$"Горизонтальные штрихи/G7".text = str(x0 + Dx * 0.375)
	$"Горизонтальные штрихи/G8".text = str(x0 + Dx * 0.5)
func _draw():
	var x = x0 - Dx/2
	var kon_x = x0 + Dx/2
	draw_rect(Rect2(0, 0, 1024, 600), Color.white)
	while x <= kon_x:
		var koef_mash = (x - x0 + Dx/2)/Dx
		if x != 0:
			draw_circle(Vector2(200 + 600 * koef_mash, 300 - uvel_y*1.0/x), 1, Color.green)
		draw_circle(Vector2(200 + 600 * koef_mash, 300 - uvel_y*x), 1, Color.green)
		draw_circle(Vector2(200 + 600 * koef_mash, 300.0 - uvel_y*rfp(x, mass_p, 0)), 1, Color.blue)
		draw_circle(Vector2(200 + 600 * koef_mash, 300.0 - uvel_y*nfp(x, mass_p, 0)), 1, Color.red)
		draw_circle(Vector2(200 + 600 * koef_mash, 300), 1, Color.black)
#		draw_circle(Vector2(200 + x * 600/ Dx, 260), 1, Color.brown)
#		draw_circle(Vector2(230, 100 + x/Dx*400), 1, Color.brown)
		draw_circle(Vector2(200, 100 + 400 * koef_mash), 1, Color.black)
		if int(400 * koef_mash) % 50 == 0:
			for i in range(0, 20):
				draw_circle(Vector2(210 - i, 100 + 400 * koef_mash), 1, Color.black)
		x += Dx/kol_x
		if int(800 * koef_mash) % 100 == 0:
			for i in range(0, 20):
				draw_circle(Vector2(200 + 600 * koef_mash, 310 - i), 1, Color.black)
	for i in range(0, 20):
		draw_circle(Vector2(210 - i, 500), 1, Color.black)
	pass
func _process(delta):
	pred_uvel_y = uvel_y
	uvel_y = $Y.value
	if uvel_y != pred_uvel_y:
		if uvel_y <= 0:
			uvel_y = 1
		else:
			mash_y.text = str(uvel_y)
		get_tree().reload_current_scene()

func rfp (x, mass, shag):
	var pn = mass[len(mass) - 1].znach
	if shag != 0:
		pn += shag
	var mu_0 = 4 * PI * 0.0001 * 0.0001 * 0.01
	var znam = mass[0].znach / (mu_0 * 50 * 60) + 2 * x / (mu_0 * 60);
	if znam != 0:
		return (mass[1].znach *  mass[1].znach / znam)
	else:
		return(100_000_000_000_000_000_000.0)

func nfp (x, mass, shag):
	var pn = mass[len(mass) - 1].znach
	if shag != 0:
		pn += shag;
	return (mass[2].znach*x + pn)
