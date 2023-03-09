import sys
payment_dict={}
for line in sys.stdin:
	line=line.strip()
	payment,count=line.split('\t')
	count=int(count)
	if payment in payment_dict:
		payment_dict[payment]+=count
	else:
		payment_dict[payment].append(count)
#reducer
for payment in sorted(payment_dict.items(),key=(lambda x: x[1])):
	print(payment+"\t"+str(payment_dict[payment]))
	
