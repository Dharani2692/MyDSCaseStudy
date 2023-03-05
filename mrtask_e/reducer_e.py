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
sorted_keys =[int(i) for i in list(location_dict.keys())]

for loc in sorted(sorted_keys):
    location=str(loc)
    tip_avg=float(location_dict[location][1])/location_dict[location][0]
    total_avg=float(location_dict[location][2])/location_dict[location][0]
    print(location+"\t%.2f\t%.2f"%(tip_avg,total_avg))

