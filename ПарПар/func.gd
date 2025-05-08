extends Node
class_name Func

var Dx = 0.5; var x01 = 0.5; var kol_toch_x = 20; var kol_peres = 20; var kol_t_per = 20
var kol_perem = 4; var razm_topa = 20;

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

func vx_data(mass_p):
	mass_p[0].imya = 'l'
	mass_p[0].min_z = 1.0; mass_p[0].max_z = 40.0

	mass_p[1].imya = 'w'
	mass_p[1].min_z = 10.0; mass_p[1].max_z = 10000.0

	mass_p[2].imya = 'k'
	mass_p[2].min_z = -5.0; mass_p[2].max_z = 0.0
	
	mass_p[3].imya = 'b'
	mass_p[3].min_z = -10000.0; mass_p[3].max_z = 10000.0;
	
	for i in range(0,len(mass_p)):
		mass_p[i].znach = mass_p[i].min_z
		mass_p[i].shag = (mass_p[i].max_z - mass_p[i].min_z)/kol_t_per
	
	
