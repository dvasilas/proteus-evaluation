import numpy as np
from matplotlib import pyplot as plt

x = [0, 1, 2, 3, 5]
p0 = [0, 80.078, 97.761, 99.991, 100]
p1 = [0, 95.453, 99.842, 100, 100]
f, ax = plt.subplots()

ax.plot(x, p1, color='b', marker='x', label='Proteus-application')
ax.plot(x, p0, color='g', marker='+', label='Proteus-client')

ax.set(xlabel='# Returned version (1 = latest)', ylabel='CDF [%]')

ax.set_ylim(bottom=0)
ax.set_xlim(left=0)

ax.grid(linestyle='dotted')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='lower right')

plt.savefig('readV_cdf_throughput.png')
plt.close()