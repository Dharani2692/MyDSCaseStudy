import sys
for line in sys.stdin:
	line=line.strip()
	line=line.split(',')
	if line[0]!="VendorID":
		if len(line)>=2:
			payment_type=line[9]
			print(payment_type+'\t1')
