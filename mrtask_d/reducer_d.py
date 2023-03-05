import sys
location_dict={}

for line in sys.stdin:
	line=line.strip()
	location,count,trip=line.split('\t')
	count,trip=int(count),float(trip)
	if location in location_dict:
		location_dict[location][1]+=trip
		location_dict[location][0]+=count
	else:
		location_dict[location]=[]
		location_dict[location].append(count)
		location_dict[location].append(trip)
#reducer
for location in location_dict.keys():
	avg=float(location_dict[location][1]/location_dict[location][0])
	print(location+"\t%.2f"%avg)

