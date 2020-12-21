import matplotlib.pyplot as plt

throughput_lobsters = [500.00018, 1000.00049, 1999.97597, 3000.1013, 4000.27737, 4499.97726, 4999.75249, 5499.80305, 5699.97751, 5791.55283]
respTime_lobsters = [81.70224,    81.70687,   82.69064,   82.79342,  85.07017,   83.71914,   84.84691,   91.33331,   106.54948,  165.14621]

throughput_proteus_datastore = [499.975,1000.00001,2000.00002,2995.85149,4000.10194,4100.15211,4200.55202,4302.75206]
respTime_lobsters_datastore = [83.25554,83.26093,83.89383,87.98632,93.68136,94.86974,97.29494,431.88952]

throughput_proteus_client = [ 499.9753, 1000.05055, 2000.00135, 3000.30403, 3998.75225, 5000.05366, 6000.9,   6501.32089, 7057.67988, 7275.02368, 7553.42848, 7698.7791,7831.91119,7865.65948]
respTime_lobsters_client = [  2.63942,  3.01543,    4.65687,    8.30447,    18.94158,   29.33482,   23.48175, 26.08507,   30.04863,   32.24758,   50.65336,   81.07866,114.75306,138.39679]

throughput_baseline_db = [500.00031,1000.00048,2000.00115,3000.05154,4000.00245,5000.0314,6000.05545,6999.97927,8000.08028,9000.00585,9099.97976,9200.08138,9500.08027,9600.38121,9706.37996,9701.25524,9750.72258,9681.43122,9691.05535,9630.00852,9486.73123,9318.25745]
respTime_baseline_db = [0.81552,0.81348,0.83594,0.90492,1.08862,1.2107,1.39493,1.56269,1.76105,2.01445,2.12129,1.84018,1.99626,2.135,5.60897,23.11631,28.14762,34.20481,39.76049,45.36878,52.10973,58.73519]

f, ax = plt.subplots()

ax.plot(throughput_lobsters, respTime_lobsters, color='k', marker='o', label='MySQL')
ax.plot(throughput_proteus_datastore, respTime_lobsters_datastore, color='b', marker='x', label='Proteus-application')
ax.plot(throughput_proteus_client, respTime_lobsters_client, color='g', marker='+', label='Proteus-client')
ax.plot(throughput_baseline_db, respTime_baseline_db, linestyle='dashdot', color='c', marker='s', label='MySQL-baseline')

ax.set(xlabel='Throughput [requests/s]', ylabel='Query response time [ms]')

ax.grid(linestyle='dotted')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='upper left')

plt.ylim([0.0, 135.0])

# plt.tight_layout(rect=[0,0.05,1,1])
plt.savefig('responseTime.png')
plt.close()