import sqlite3 as dbm
from datetime import datetime
import matplotlib.pyplot as plt

db=dbm.connect("test1.db")
dbc=db.cursor()

# gets todays date
today=str(datetime.now().strftime('%y%m%d'))

dbc.execute('select * from data where time like (?)',[today+'%'])

todaysData=dbc.fetchall()

dbc.close()
db.close()

timestamps=[]
download=[]
upload=[]

for i in todaysData:
    # timestamp in YYMMDDhhmm format
    timestamps.append(i[0][6:8]+':'+i[0][8:])
    download.append(float(i[1]))
    upload.append(float(i[2]))

fig,ax=plt.subplots()

ax.plot(timestamps,download,color='blue',label='Download')
ax.plot(timestamps,upload,color='red',linestyle='dashed',label='Upload')
ax.set_xlabel('Timestamp')
ax.set_ylabel('(in Mbit/s)')
ax.set_title('Speeds')
ax.legend()

plt.show()

