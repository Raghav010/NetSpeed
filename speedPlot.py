import sqlite3 as dbm
from datetime import datetime
import matplotlib.pyplot as plt

db=dbm.connect("test1.db")
dbc=db.cursor()

today=str(datetime.now().strftime('%y%m%d'))

dbc.execute('select * from data where time like (?)',[today+'%'])

todaysData=dbc.fetchall()

timestamps=[]
download=[]
upload=[]

for i in todaysData:
    timestamps.append(i[0][6:8]+':'+i[0][8:])
    download.append(float(i[1]))
    upload.append(float(i[2]))

fig,axes=plt.subplots(1,2,sharey=True)

axes[0].plot(timestamps,download)
axes[0].set_title('Download')
axes[0].set_xlabel('Timestamps')
axes[0].set_ylabel('Download Speed')

axes[1].plot(timestamps,upload)
axes[1].set_title('Upload')
axes[1].set_xlabel('Timestamps')
axes[1].set_ylabel('Upload Speed')

plt.show()

