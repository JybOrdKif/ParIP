extends Node2D

var formula = ["!"]
var pred_zn = ''
var pred_formul = []
var params = []
#var alphavit = []

func _ready():
	podg_knop()
	izmen_form(' ')
	

func _process(delta):
	if $"Окошка выбора".visible:
		if len($"Окошка выбора/Варианты ппараметров".get_selected_items()) > 0:
			$"Окошка выбора/Pust".visible = true
			$"Окошка выбора/Pust".rect_position.x = -90
			$"Окошка выбора/Pred".rect_position.x = 10
	if $"Анкета параметра".visible:
		if $"Анкета параметра/Первый символ имени".visible:
			if len($"Анкета параметра/Первый символ имени".get_selected_items()) > 0 && len($"Анкета параметра/Второй символ имени".get_selected_items()) > 0:
				$"Анкета параметра/Got".visible = true
				$"Анкета параметра/Got".rect_position.x = -90
				$"Анкета параметра/Got/Текст".text = "Готово"
				$"Анкета параметра/Otm".visible = true
				$"Анкета параметра/Otm".rect_position.x = 10
				$"Анкета параметра/Otm/Текст".text = "Отмена"

func podg_knop():
	$"Кнопки/Button1/Текст"
	$"Кнопки/Button1/Текст".text = "+"
	$"Кнопки/Button2/Текст".text = "-"
	$"Кнопки/Button3/Текст".text = "*"
	$"Кнопки/Button4/Текст".text = "/"
	$"Кнопки/Button5/Текст".text = "sin"
	$"Кнопки/Button6/Текст".text = "cos"
	$"Кнопки/Button7/Текст".text = "tg"
	$"Кнопки/Button8/Текст".text = "ctg"
	$"Кнопки/Button9/Текст".text = "arcsin"
	$"Кнопки/Button10/Текст".text = "arccos"
	$"Кнопки/Button11/Текст".text = "arctg"
	$"Кнопки/Button12/Текст".text = "arcctg"
	$"Кнопки/Button13/Текст".text = "^"
	$"Кнопки/Button14/Текст".text = "e^"
	$"Кнопки/Button15/Текст".text = "pi"
	$"Кнопки/Button16/Текст".text = "="
	$"Кнопки/Button17/Текст".text = "("
	$"Кнопки/Button18/Текст".text = ")"
	$"Кнопки/Button19/Текст".text = "<"
	$"Кнопки/Button20/Текст".text = ">"
	$"Кнопки/Button21/Текст".text = "Число"
	$"Кнопки/Кнопка22/Текст".text = "Параметр"
	$"Кнопки/Button23/Текст".text = "Отмена"
func izmen_form(znak):
	var nom = 1000
	for i in range(0, len(formula)):
		if formula[i] == "!":
			nom = i
			break
	if znak == '+' || znak == '-' || znak == '/' || znak == '*' || znak == '=' || znak == '^':
		if ((pred_zn == '+' || pred_zn == '-') && (znak == '+' || znak == '-')) || (pred_zn == '*' && znak == '*') || (pred_zn == '/' && znak == '/') || znak == '=':
			nov_mesto(nom, 2)
			formula[nom] = " "
			formula[nom + 1] = znak
			formula[nom + 2] = "!"
		else:
			nov_mesto(nom, 4)
			formula[nom] = "("
			formula[nom + 1] = " "
			formula[nom + 2] = znak
			formula[nom + 3] = "!"
			formula[nom + 4] = ")"
	var odn_knop = ["sin", "cos", "tg", "ctg", "arcsin", "arccos", "arctg", "arcctg", "e^"]
	for nazv in odn_knop:
		if nazv == znak:
			nov_mesto(nom, 3)
			formula[nom] = "("
			formula[nom + 1] = znak
			formula[nom + 2] = "!"
			formula[nom + 3] = ")"
	if znak == "Параметр":
		formula[nom] = $"Окошка выбора/Варианты ппараметров".get_item_text($"Окошка выбора/Варианты ппараметров".get_selected_items()[0]).split(' ')[0]
		nov_tek_pos(nom)
	if znak == "pi" || (znak[0] >= "0" && znak[0] <= "9"):
		formula[nom] = znak
		nov_tek_pos(nom)
	if znak.split('|')[0] == "Число":
		var chislo = float(znak.split('|')[1])
		if chislo >= 0:
			formula[nom] = str(chislo)
		else:
			nov_mesto(nom, 2)
			formula[nom] = "("
			formula[nom + 1] = str(chislo)
			formula[nom + 2] = ")"
		nov_tek_pos(nom)
	if znak == "<":
		formula[nom] = " "
		for i in range(nom - 1, -1, -1):
			if formula[i] == " ":
				formula[i] = "!"
				break
	if znak == ">":
		formula[nom] = " "
		for i in range(nom + 1, len(formula)):
			if formula[i] == " ":
				formula[i] = "!"
				break
	print(formula)
	
	if znak != '<' && znak != '>':
		zapomin(znak, formula)
	print(pred_formul,"\n")
	obnovl_ekr()
	nom = 1000
	for i in range(0, len(formula)):
		if formula[i] == "!":
			nom = i
			break
	if nom >= 1000:
		block_buttons(1, true)
func nov_mesto(nom, kol_vo):
	for i in range(0, kol_vo):
		formula.append("")
		for j in range(len(formula) - 1, nom, -1):
			formula[j] = formula[j - 1]
func nov_tek_pos(nom):
	var min_r = 1000; var i_min = 1000
	for i in range(0, len(formula)):
		if formula[i] == " " && abs(i - nom) < min_r:
			i_min = i
			min_r = abs(i - nom)
	if i_min < 1000:
		formula[i_min] = "!"

func obnovl_ekr():
	var kol_prob = [0, 0];
	for i in range(0, len(formula)):
		if formula[i] == "!":
			for j in range(0, len(formula)):
				if j < i && formula[j] == " ":
					kol_prob[0] += 1
				if formula[j] == " " && j > i:
					kol_prob[1] += 1
			break
	if kol_prob[0] > 0:
		$"Кнопки/Button19".visible = true
	else:
		$"Кнопки/Button19".visible = false
	if kol_prob[1] > 0:
		$"Кнопки/Button20".visible = true
	else:
		$"Кнопки/Button20".visible = false
	
	if len(pred_formul) > 1:
		$"Кнопки/Button23".visible = true
	else:
		$"Кнопки/Button23".visible = false
	
	$"Экран/RichTextLabel".text = ""
#	print(formula)
	for el in formula:
		$"Экран/RichTextLabel".text += el
func zapomin(znak, tek_form):
	pred_zn = znak
	if len(pred_formul) < 10:
		pred_formul.append("")
	if len(pred_formul) > 1:
		for i in range(len(pred_formul) - 1, 0, -1):
			pred_formul[i] = pred_formul[i - 1]
	pred_formul[0] = []
	for i in tek_form:
		pred_formul[0].append(i)
func block_buttons(vid, lock):
	var vis = !lock
	$"Кнопки/Button1".visible = vis
	$"Кнопки/Button2".visible = vis
	$"Кнопки/Button3".visible = vis
	$"Кнопки/Button4".visible = vis
	$"Кнопки/Button5".visible = vis
	$"Кнопки/Button6".visible = vis
	$"Кнопки/Button7".visible = vis
	$"Кнопки/Button8".visible = vis
	$"Кнопки/Button9".visible = vis
	$"Кнопки/Button10".visible = vis
	$"Кнопки/Button11".visible = vis
	$"Кнопки/Button12".visible = vis
	$"Кнопки/Button13".visible = vis
	$"Кнопки/Button14".visible = vis
	$"Кнопки/Button15".visible = vis
	$"Кнопки/Button16".visible = vis
	$"Кнопки/Button17".visible = vis
	$"Кнопки/Button18".visible = vis
	$"Кнопки/Button19".visible = vis
	$"Кнопки/Button20".visible = vis
	$"Кнопки/Button21".visible = vis
	$"Кнопки/Кнопка22".visible = vis
	if vid == 2:
		$"Кнопки/Button23".visible = vis

func _on_Button1_pressed():
	izmen_form($"Кнопки/Button1/Текст".text)
func _on_Button2_pressed():
	izmen_form($"Кнопки/Button2/Текст".text)
func _on_Button3_pressed():
	izmen_form($"Кнопки/Button3/Текст".text)
func _on_Button4_pressed():
	izmen_form($"Кнопки/Button4/Текст".text)
func _on_Button5_pressed():
	izmen_form($"Кнопки/Button5/Текст".text)
func _on_Button6_pressed():
	izmen_form($"Кнопки/Button6/Текст".text)
func _on_Button7_pressed():
	izmen_form($"Кнопки/Button7/Текст".text)
func _on_Button8_pressed():
	izmen_form($"Кнопки/Button8/Текст".text)
func _on_Button9_pressed():
	izmen_form($"Кнопки/Button9/Текст".text)
func _on_Button10_pressed():
	izmen_form($"Кнопки/Button10/Текст".text)
func _on_Button11_pressed():
	izmen_form($"Кнопки/Button11/Текст".text)
func _on_Button12_pressed():
	izmen_form($"Кнопки/Button12/Текст".text)
func _on_Button13_pressed():
	izmen_form($"Кнопки/Button13/Текст".text)
func _on_Button14_pressed():
	izmen_form($"Кнопки/Button14/Текст".text)
func _on_Button15_pressed():
	izmen_form($"Кнопки/Button15/Текст".text)
func _on_Button16_pressed():
	izmen_form($"Кнопки/Button16/Текст".text)
func _on_Button17_pressed():
	izmen_form($"Кнопки/Button17/Текст".text)
func _on_Button18_pressed():
	izmen_form($"Кнопки/Button18/Текст".text)
func _on_Button19_pressed():
	izmen_form($"Кнопки/Button19/Текст".text)
func _on_Button20_pressed():
	izmen_form($"Кнопки/Button20/Текст".text)
func _on_Button21_pressed():
	block_buttons(2, true)
	$"Окошко ввода".visible = true
	$"Окошко ввода/Вопрос".text = "Введите число, которое\nхотите добавить в формулу."
	$"Окошко ввода/Место для чисел".readonly = false
	$"Окошко ввода/Yes".visible = true
	$"Окошко ввода/Yes/Текст".text = "Готово"
	$"Окошко ввода/No".visible = true
	$"Окошко ввода/No/Текст".text = "Отмена"
func _on_Button22_pressed():
	$"Окошка выбора/Варианты ппараметров".clear()
	for i in range(0, len(params)):
		var string = params[i].imya + ' min:' + str(params[i].min_z) + ', max:' + str(params[i].max_z)
		$"Окошка выбора/Варианты ппараметров".add_item(string)
	if len(params) < 7:
		$"Окошка выбора/Варианты ппараметров".add_item("Новый параметр")
	
	$"Окошка выбора".visible = true
	$"Окошка выбора/Pust".visible = false
	$"Окошка выбора/Pust/Текст".text = "Готово"
	$"Окошка выбора/Pred".visible = true
	$"Окошка выбора/Pred".rect_position.x = -40
	$"Окошка выбора/Pred/Текст".text = "Отмена"
	$"Окошка выбора/Вопрос".text = "Выберите параметр, который хотите добавить в формулу."
	block_buttons(2, true)
func _on_Button23_pressed():
	if len(pred_formul) > 1:
		pred_formul[0] = ""
		pred_formul.erase("")
		formula = []
		for i in range(0, len(pred_formul[0])):
			formula.append(pred_formul[0][i])
		
		print(pred_formul, "\n")
		for i in range(0, len(formula)):
			if formula[i] == "!":
				block_buttons(1, false)
				break
		obnovl_ekr()


func _on_Yes_pressed():
	match $"Окошко ввода/Yes/Текст".text:
		"Готово":
			$"Окошко ввода/Вопрос".text = "Вы хотели ввести\nследующее число?"
			$"Окошко ввода/Место для чисел".text = str(float($"Окошко ввода/Место для чисел".text))
			$"Окошко ввода/Место для чисел".readonly = true
			$"Окошко ввода/Yes".visible = true
			$"Окошко ввода/Yes".rect_position.x = -90
			$"Окошко ввода/Yes/Текст".text = "Да"
			$"Окошко ввода/No".visible = true
			$"Окошко ввода/No/Текст".text = "Нет"
		"Да":
			block_buttons(2, false)
			izmen_form("Число|" + str(float($"Окошко ввода/Место для чисел".text)))
			$"Окошко ввода".visible = false
func _on_No_pressed():
	match $"Окошко ввода/No/Текст".text:
		"Нет":
			$"Окошко ввода/Вопрос".text = "Введите число, которое\nхотите добавить в формулу."
			$"Окошко ввода/Место для чисел".readonly = false
			$"Окошко ввода/Yes".visible = true
			$"Окошко ввода/Yes/Текст".text = "Готово"
			$"Окошко ввода/No".visible = true
			$"Окошко ввода/No/Текст".text = "Отмена"
		"Отмена":
			$"Окошко ввода".visible = false
			block_buttons(2, false)
			obnovl_ekr()
func _on_Pust_pressed():
	$"Окошка выбора".visible = false
	if $"Окошка выбора/Варианты ппараметров".get_item_text($"Окошка выбора/Варианты ппараметров".get_selected_items()[0]) == "Новый параметр":
		$"Анкета параметра".visible = true
		$"Анкета параметра/Вопрос".text = "Заполните анкету парамета."
		$"Анкета параметра/Подписи/Имя".visible = true
		$"Анкета параметра/Первый символ имени".visible = true
		$"Анкета параметра/Второй символ имени".visible = true
		$"Анкета параметра/Минимум".readonly = false
		$"Анкета параметра/Максимум".readonly = false
		$"Анкета параметра/Первый символ имени".clear()
		$"Анкета параметра/Второй символ имени".clear()
		$"Анкета параметра/Второй символ имени".add_item('-')
		for i in (range(97, 123) + range(65, 91)):
			$"Анкета параметра/Первый символ имени".add_item("%c" % i)
			$"Анкета параметра/Второй символ имени".add_item("%c" % i)
		$"Анкета параметра/Got".visible = false
		$"Анкета параметра/Otm".visible = true
		$"Анкета параметра/Otm".rect_position.x = -40
		$"Анкета параметра/Otm/Текст".text = "Отмена"
	else:
		block_buttons(2, false)
		izmen_form("Параметр")
func _on_Pred_pressed():
	match $"Окошка выбора/Pred/Текст".text:
		"Отмена":
			$"Окошка выбора".visible = false
			block_buttons(2, false)
			obnovl_ekr()
func _on_Got_pressed():
	var imya = 'pexota'
	match $"Анкета параметра/Got/Текст".text:
		"Готово":
			$"Анкета параметра/Подписи/Имя".visible = false
			$"Анкета параметра/Первый символ имени".visible = false
			$"Анкета параметра/Второй символ имени".visible = false
			$"Анкета параметра/Максимум".readonly = true
			$"Анкета параметра/Минимум".readonly = true
			
			var sovp_im = false
			var sym1 = $"Анкета параметра/Первый символ имени".get_item_text($"Анкета параметра/Первый символ имени".get_selected_items()[0])
			var sym2 = $"Анкета параметра/Второй символ имени".get_item_text($"Анкета параметра/Второй символ имени".get_selected_items()[0])
			if sym2 == '-':
				imya = sym1
			else:
				imya = sym1 + sym2
			for i in range(0,len(params)):
				if params[i].imya == imya:
					sovp_im = true
			var max_z = float($"Анкета параметра/Максимум".text)
			var min_z = float($"Анкета параметра/Минимум".text)
			if imya == "tg" || imya == "pi" || max_z <= min_z || sovp_im:
				$"Анкета параметра/Got".visible = false
				$"Анкета параметра/Otm".visible = true
				$"Анкета параметра/Otm".rect_position.x = -40
				$"Анкета параметра/Otm/Текст".text = "Назад"
				if imya == "tg" || imya == "pi":
					$"Анкета параметра/Вопрос".text = "Введено недопустимое\nимя переменной (tg или pi)."
				else:
					if sovp_im:
						$"Анкета параметра/Вопрос".text = "Переменная с таким именем (" + imya + ")\nуже существует."
					else:
						$"Анкета параметра/Вопрос".text = "Максимум должен\nбыть строго больше\nминимума."
			else:
				$"Анкета параметра/Got".visible = true
				$"Анкета параметра/Got".rect_position.x = -90
				$"Анкета параметра/Got/Текст".text = "Да"
				$"Анкета параметра/Otm".visible = true
				$"Анкета параметра/Otm".rect_position.x = 10
				$"Анкета параметра/Otm/Текст".text = "Нет"
				$"Анкета параметра/Минимум".text = str(float($"Анкета параметра/Минимум".text))
				$"Анкета параметра/Максимум".text = str(float($"Анкета параметра/Максимум".text))
				$"Анкета параметра/Вопрос".text = "Вы хотели добавить параметр\nс именем " + imya + ",\nа также следующими\nминимумом и максимумом?"
		"Да":
			params.append(load("res://Переменная.gd").new())
			var sym1 = $"Анкета параметра/Первый символ имени".get_item_text($"Анкета параметра/Первый символ имени".get_selected_items()[0])
			var sym2 = $"Анкета параметра/Второй символ имени".get_item_text($"Анкета параметра/Второй символ имени".get_selected_items()[0])
			if sym2 == '-':
				params[-1].imya = sym1
			else:
				params[-1].imya = sym1 + sym2
			params[-1].max_z = float($"Анкета параметра/Максимум".text)
			params[-1].min_z = float($"Анкета параметра/Минимум".text)
			$"Анкета параметра".visible = false
			_on_Button22_pressed()
func _on_Otm_pressed():
	match $"Анкета параметра/Otm/Текст".text:
		"Отмена":
			$"Анкета параметра".visible = false
			block_buttons(2, false)
		"Назад":
			vozvr_ank()
		"Нет":
			vozvr_ank()
func vozvr_ank():
	$"Анкета параметра/Вопрос".text = "Заполните анкету парамета."
	$"Анкета параметра/Подписи/Имя".visible = true
	$"Анкета параметра/Первый символ имени".visible = true
	$"Анкета параметра/Второй символ имени".visible = true
	$"Анкета параметра/Максимум".readonly = false
	$"Анкета параметра/Минимум".readonly = false
	$"Анкета параметра/Got".visible = true
	$"Анкета параметра/Got".rect_position.x = -90
	$"Анкета параметра/Got/Текст".text = "Готово"
	$"Анкета параметра/Otm".visible = true
	$"Анкета параметра/Otm".rect_position.x = 10
	$"Анкета параметра/Otm/Текст".text = "Отмена"
