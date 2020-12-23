import matplotlib.pyplot as plt

write_throughput_client = [500.07527,1000.00041,2000.12605,2500.32767,2999.35171,3500.61361,3961.22224,4250.66576]
fr_latency_client = [44.81815,44.86404,45.58942,46.48124,47.94805,49.24694,49.38624,49.28085]

write_throughput_datastore = [500.00034,1000.00037,2000.02611,2499.95105,3000.05147,3501.33461,4026.1502,4251.92629]
fr_latency_datastore = [4.62999,4.77834,6.01891,7.67693,9.82936,13.00829,15.16461,18.518]

f, ax = plt.subplots()

ax.plot(write_throughput_datastore, fr_latency_datastore, color='b', marker='x', label='Proteus-application')
ax.plot(write_throughput_client, fr_latency_client, color='g', marker='+', label='Proteus-client')

ax.set(xlabel='Throughput [requests/s]', ylabel='95-th %-ile update latency [ms]')

ax.grid(linestyle='dotted')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='center left')

plt.tight_layout(rect=[0,0.05,1,1])
plt.savefig('fr_latency_throughput.png')
plt.close()