var mass = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var pogr = 100_000_000
var sum_rfp = 0
var otn_pogr = 100_000

func prisv(otkuda):
	for i in range(0, len(mass)):
		mass[i] = otkuda.mass[i]
	pogr = otkuda.pogr
	sum_rfp = otkuda.sum_rfp
	otn_pogr = otkuda.otn_pogr
func zapoln(perem, pogr_n, sum_f):
	for i in range(0, len(perem)):
		mass[i] = perem[i]
	pogr = pogr_n
	sum_rfp = sum_f
	otn_pogr = pogr_n / sum_f * 100
