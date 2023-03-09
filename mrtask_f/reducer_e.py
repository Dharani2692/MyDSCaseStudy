import sys
month_dict={}
day_dict={}
daytime_dict = {}
for line in sys.stdin:
	line=line.strip()
	month,count,day,daytime,amount=line.split('\t')
	count,amount=int(count),float(amount)
#month
	if month in month_dict:
		month_dict[month][1]+=amount
		month_dict[month][0]+=count
	else:
		month_dict[month]=[]
		month_dict[month].append(count)
		month_dict[month].append(amount)
#day
	if day in day_dict:
		day_dict[day][1]+=amount
		day_dict[day][0]+=count
	else:
		day_dict[day]=[]
		day_dict[day].append(count)
		day_dict[day].append(amount)
#daytime
	if daytime in daytime_dict:
		daytime_dict[daytime][1]+=amount
		daytime_dict[daytime][0]+=count
	else:
		daytime_dict[daytime]=[]
		daytime_dict[daytime].append(count)
		daytime_dict[daytime].append(amount)
#month
for month in month_dict.keys():
	month_avg=month_dict[month][1]/month_dict[month][0]
	print('1'+month+"\t%.2f"%month_avg)

#day
for day in day_dict.keys():
	day_avg=day_dict[day][1]/day_dict[day][0]
	print('2'+day+"\t%.2f"%day_avg)

#daytime
for daytime in daytime_dict.keys():
	daytime_avg=daytime_dict[daytime][1]/daytime_dict[daytime][0]
	print('3'+daytime+"\t%.2f"%daytime_avg)
