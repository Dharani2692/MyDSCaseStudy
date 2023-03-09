import sys
from datetime import datetime
from time import strftime
import calendar
for line in sys.stdin:
    line=line.strip()
    line=line.split(',')
    if line[0]!="VendorID":
        if len(line)>=2:
            total_amount=line[16]
            pickup = datetime.strptime(line[1],"%Y-%m-%d %H:%M:%S")
            pickup_date =pickup.date() 
            month = pickup_date.strftime('%B')
            day = calendar.day_name[pickup_date.weekday()]
            hr = pickup.time().hour
            daytime = ( "day" if hr<=20 and hr>=6 else "night")
            print(month+'\t1\t'+day+'\t'+daytime+'\t'+total_amount)
