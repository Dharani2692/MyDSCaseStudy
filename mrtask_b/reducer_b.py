import sys
location_dict={}
location_count,amount_sum=0,0
for line in sys.stdin:
	line=line.strip()
	location,count,amount=line.split('\t')
	count,amount=int(count),float(amount)
	if location in location_dict:
		location_dict[location][1]+=amount
		location_dict[location][0]+=count
	else:
		location_dict[location]=[]
		location_dict[location].append(count)
		location_dict[location].append(amount)
#reducer
high = 0.0
for location in location_dict.keys():
	if high < location_dict[location][1]:
		high = location_dict[location][1]
		loc=location
print(loc+"\t"+str(location_dict[loc][0])+'\t'+'%.2f'%location_dict[loc][1])
	
