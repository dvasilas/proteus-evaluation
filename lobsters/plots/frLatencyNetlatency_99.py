import matplotlib.pyplot as plt

netLatency = [0, 10, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]
fr_latency = [10.2157,10.24781,10.37871,9.18627,8.75541,10.48504,10.2082,12.85111,9.89153,11.09457,10.73589,22.00419,15.0772,14.29934,16.05631,30.69353,54.17463]


f, ax = plt.subplots()

ax.plot(netLatency, fr_latency, color='k', marker='o')

ax.set_ylim(bottom=0)
ax.set_xlim(left=0)

ax.set(xlabel='Round-trip time between sites [ms]', ylabel='99-th %-ile update latency (normalized) [ms]')

ax.grid(linestyle='dotted')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='upper left')

plt.savefig('fr_latency_net_latency_99_norm.png')
plt.close()