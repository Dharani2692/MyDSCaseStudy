import sys
from datetime import datetime
for line in sys.stdin:
    line=line.strip()
    line=line.split(',')
    if line[0]!="VendorID":
        if len(line)>=2:
            PULocationID=line[7]
            tip_amount=line[13]
            total_amount=line[16]
            print(PULocationID+'\t1\t'+str(tip_amount)+'\t'+str(total_amount))

