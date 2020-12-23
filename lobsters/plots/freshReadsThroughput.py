import matplotlib.pyplot as plt

throughput_client =[500.07527,1000.00041,2000.12605,2500.32767,2999.35171,3500.61361,3956.37687,4250.66576]
throughput_ratastore = [500.00034,1000.00037,2000.02611,2499.95105,3000.05147,3501.33461,4026.1502,4251.92629]
freshR_datastore = [99.826,99.567,99.071,98.734,98.327,97.732,95.813,95.453]
freshR_client = [97.346,94.781,89.922,87.708,85.294,83.081,81.651,80.078]
freshR_datastore1 = [100,100,99.996,99.99,99.982,99.961,99.854,99.842]
freshR_client1 = [99.966,99.865,99.457,99.193,98.807,98.42,98.333,97.761]

f, ax = plt.subplots()

ax.plot(throughput_ratastore, freshR_datastore, color='b', marker='x', label='Proteus-application [fresh read: k=1]')
ax.plot(throughput_ratastore, freshR_datastore1, color='b', linestyle='dashed', marker='x', label='Proteus-application [fresh read: k<=2]')
ax.plot(throughput_client, freshR_client, color='g', marker='+', label='Proteus-client [fresh read: k=1]')
ax.plot(throughput_client, freshR_client1, color='g', linestyle='dashed', marker='+', label='Proteus-client [fresh read: k<=2]')

ax.set(xlabel='Throughput [requests/s]', ylabel='Fresh query results [%]')

ax.set_ylim(bottom=0)

ax.grid(linestyle='dotted')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='lower left')

plt.savefig('fresh_reads_throughput.png')
plt.close()