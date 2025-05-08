extends Func
onready var Dan = get_node("/root/DanGraf")
var Perem = load("res://Переменная.gd")
var Nabor_perem = load('res://Набор переменных.gd')

var min_otn_pogr = 10_000


func _ready():
	var mass_p = []; var top = [];
	
	create_struct(mass_p, top, kol_perem, razm_topa)
	vx_data(mass_p);
	var kon = x01 + Dx/2
	var x = x01 - Dx/2
	while x <= kon:
		podbor_perem(0, kol_perem, mass_p, x, Dx, top)
		x += Dx/kol_peres
	
	for i in range(0, razm_topa):
		if top[i].sum_rfp == 0:
			break
		print(top[i].mass, ' ', top[i].pogr, ' ', top[i].sum_rfp, ' ', top[i].pogr/top[i].sum_rfp*100, '%')
	
	print("Готово.")
	Dan.text = str(x01) + ' ' + str(Dx) + ' '
	for i in range(0, len(mass_p)):
		Dan.text += str(top[0].mass[i])
		if i != len(mass_p) - 1:
			Dan.text += ' '
	print(Dan.text)
	get_tree().change_scene("res://Рисование графика.tscn")


func step(a, x):
	var rez = 1.0
	if x > 0:
		while x > 0:
			rez = rez * a
			x -= 1
	else:
		if x < 0:
			while x < 0:
				rez = rez / a
				x += 1
	return (rez)
func create_struct(mass, top, kol_perem, razm_topa):
	for i in range(0,kol_perem):
		var one = Perem.new()
		mass.append(one)
	for i in range(0, razm_topa):
		var stroka = Nabor_perem.new()
		top.append(stroka)
func obnovl_sp(top, mass, pogr, sum_r):
	var nom = 10*len(top)
	var perem = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	var otn_pogr = pogr/sum_r*100
	for i in range(0, len(mass)):
		perem[i] = mass[i].znach
		#printf("%10f", perem[i]);
	for i in range(0, len(top)):
		if otn_pogr < top[i].otn_pogr:
			nom = i
			break
	if nom < len(top):
		if len(top) < razm_topa:
			var stroka = Nabor_perem.new()
			top.append(stroka)
		for i in range(len(top) - 1, nom, -1):
			top[i].prisv(top[i - 1])
		top[nom].zapoln(perem, pogr, sum_r)

func podbor_perem(nom, kol_perem, mass, x0, Dx, top):
	var shag = mass[nom].shag
	
	mass[nom].znach = mass[nom].min_z
	if nom != kol_perem - 1:
		while mass[nom].znach <= mass[nom].max_z:
			podbor_perem(nom + 1, kol_perem, mass, x0, Dx, top);
			mass[nom].znach += shag
	else:
		var razn = 0; var b_razn = 0; var x2b_razn = 0;var x10e6razn = 0;var x10e6b_razn = 0
		while abs(rfp(x0, mass, 0) - nfp(x0, mass, 0)) > 0.000_000_001:
			razn = rfp(x0, mass, 0) - nfp(x0, mass, 0);
			b_razn = rfp(x0, mass, shag) - nfp(x0, mass, shag);
			x2b_razn = rfp(x0, mass, 2*shag) - nfp(x0, mass, 2*shag);
			if (abs(b_razn) > abs(razn)):
				if abs(razn) <= 0.5*abs(b_razn - razn):
					shag /= 2.0;
				else:
					shag = -shag;
			else:
				if (mass[nom].znach > mass[nom].max_z || mass[nom].znach < mass[nom].min_z):
					break;
				if (abs(x2b_razn) < abs(b_razn) && abs(b_razn-razn) < 1/(2*kol_t_per)*abs(razn)):
					shag *= 2;
				mass[nom].znach += shag;
#			print(rfp(x0, mass, 0), ' ', mass[0].znach, ' ', mass[1].znach, ' ', mass[nom].znach, ' ', shag, ' ', shag*100);
		if (mass[nom].znach <= mass[nom].max_z && mass[nom].znach >= mass[nom].min_z):
			var pogreshn = 0.0; var x = x01 - Dx/2
			var kon_x = x01 + Dx/2
			var sum_f = 0
			while x <= kon_x:
				pogreshn += abs(rfp(x, mass, 0) - nfp(x, mass, shag));
				sum_f += abs(nfp(x, mass, 0))
				x += Dx/kol_toch_x
			obnovl_sp(top, mass, pogreshn, sum_f);
			if pogreshn/sum_f*100 < min_otn_pogr:
				min_otn_pogr = pogreshn/sum_f*100
			
			var pech_param = str(x0)
			for i in range(0, kol_perem):
				pech_param += ' ' + str(mass[i].znach)
			print(pech_param, ' ', pogreshn);
