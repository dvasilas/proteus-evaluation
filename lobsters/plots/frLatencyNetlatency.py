import matplotlib.pyplot as plt

netLatency = [0, 10, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]
fr_latency_200 = [5.7249,10.60043,15.63741,25.35382,35.39482,45.42421,55.40255,65.50717,75.33749,85.68826,95.45767,105.90026,115.67437,125.67832,135.9387,145.90136,156.50457]
fr_latency_400 = [10.17958,12.92751,18.06492,28.11171,38.7885,48.50991,58.69654,68.99132,79.23643,89.25728,100.34158,109.35684,119.68317,130.28917,140.27902,151.04793,161.63619]

f, ax = plt.subplots()

ax.plot(netLatency, fr_latency_200, color='k', marker='o', label='2000 requests/s')
ax.plot(netLatency, fr_latency_400, color='c', marker='s', label='4000 requests/s')

ax.set_ylim(bottom=0)
ax.set_xlim(left=0)

ax.set(xlabel='Round-trip time between sites [ms]', ylabel='95-th %-ile update latency [ms]')

ax.grid(linestyle='dotted')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='upper left')

plt.savefig('fr_latency_net_latency.png')
plt.close()