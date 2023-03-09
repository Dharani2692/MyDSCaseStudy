import sys
location_dict={}

for line in sys.stdin:
	line=line.strip()
	location,count,tip,total=line.split('\t')
	count,tip,total=int(count),float(tip),float(total)
	if location in location_dict:
		location_dict[location][2]+=total
		location_dict[location][1]+=tip
		location_dict[location][0]+=count
	else:
		location_dict[location]=[]
		location_dict[location].append(count)
		location_dict[location].append(tip)
		location_dict[location].append(total)
#reducer
for location in location_dict.keys():
	print(location+"\t"+str(location_dict[location][0])+'\t%.2f\t%.2f'%(location_dict[location][1],location_dict[location][2]))

