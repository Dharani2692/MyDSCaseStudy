import sys
vendor_dict={}
vendor_count,amount_sum=0,0
for line in sys.stdin:
	line=line.strip()
	vendor,count,amount=line.split('\t')
	count,amount=int(count),float(amount)
	if vendor in vendor_dict:
		vendor_dict[vendor][1]+=amount
		vendor_dict[vendor][0]+=count
	else:
		vendor_dict[vendor]=[]
		vendor_dict[vendor].append(count)
		vendor_dict[vendor].append(amount)
#reducer
for vendor in vendor_dict.keys():
	print(vendor+"\t"+str(vendor_dict[vendor][0])+'\t'+'%.2f'%vendor_dict[vendor][1])
