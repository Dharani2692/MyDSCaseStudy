import sys
for line in sys.stdin:
	line=line.strip()
	line=line.split(',')
	#skipping th header line
	if line[0]!="VendorID":
		if len(line)>=2:
			VendorID=line[0]
			total_amount=line[16]
			print(VendorID+'\t1\t'+total_amount)