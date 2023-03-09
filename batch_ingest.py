#create connection
import happybase
connection = happybase.Connection("localhost")
#open connection
def open_connection():
	connection.open()
	print("connection opened")
#close connection
def close_connection():
	connection.close()
	print("connection closed")
#get the pointer to the table
def get_table(name):
	open_connection()
	table=connection.table(name)
	print("connected to hbase table")
	close_connection()
	return table

#batch insert
def batch_insert_data(filename):
    print("starting batch insert")
    file = open(filename, "r")
    table = get_table('yellowtaxi')
    open_connection()
    i = 0
    with table.batch(batch_size=20) as b:
      for line in file:
         if i!=0:
            temp = line.strip().split(",")
            #as we have already imported 18880595 records using sqoop import
            key=18880595+i 
            b.put(b'%04d' % key, {b'Vendor:VendorID':temp[0],
                                  b'trip_info:tpep_pickup_datetime':temp[1],
                                  b'trip_info:tpep_dropoff_datetime':temp[2],
                                  b'trip_info:passenger_count':temp[3],
                                  b'trip_info:trip_distance':temp[4],
                                  b'trip_info:RatecodeID':temp[5],
                                  b'trip_info:store_and_fwd_flag':temp[6],
                                  b'location:PULocationID':temp[7],
                                  b'location:DOLocationID':temp[8],
                                  b'payment_info:payment_type':temp[9],
                                  b'payment_info:fare_amount':temp[10],
                                  b'payment_info:extra':temp[11],
                                  b'payment_info:mta_tax':temp[12],
                                  b'payment_info:tip_amount':temp[13],
                                  b'payment_info:tolls_amount':temp[14],
                                  b'payment_info:improvement_surcharge':temp[15],
                                  b'payment_info:total_amount':temp[16],
                                  b'payment_info:congestion_surcharge':temp[17],
                                  b'payment_info:airport_fee':temp[18]})
         i+=1

    file.close()
    print("batch insert done")
    close_connection()


batch_insert_data('yellow_tripdata_2017-01.csv')
