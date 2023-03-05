import sys
from datetime import datetime
for line in sys.stdin:
    line=line.strip()
    line=line.split(',')
    if line[0]!="VendorID":
        if len(line)>=2:
            PULocationID=line[7]
            tripdiff=(datetime.strptime(line[2],"%Y-%m-%d %H:%M:%S"))-(datetime.strptime(line[1],"%Y-%m-%d %H:%M:%S"))
            triptime=(tripdiff.seconds)/60
            print(PULocationID+'\t1\t%.2f'%triptime)

