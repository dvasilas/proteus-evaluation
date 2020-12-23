import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

x = [0, 10, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]
readV = {
    '1': [97.688,95.267,93.228,88.961,84.557,81.864,77.42,73.992,70.562,67.594,65.111,60.95,57.583,55.423,52.503,49.801,47.23],
    '2': [2.282,4.617,6.492,10.34,14.181,16.386,19.875,22.373,24.351,26.583,27.911,30.151,31.955,32.377,34.046,34.903,35.588],
    '3-4': [0.03,0.115,0.28,0.698,1.257,1.747,2.691,3.615,5.058,5.772,6.874,8.74,10.187,11.916,12.977,14.777,16.356],
    '>4': [0,0,0,0.001,0.005,0.003,0.014,0.02,0.029,0.052,0.104,0.159,0.274,0.284,0.473,0.519,0.826],
}

f, ax = plt.subplots()

pal = sns.color_palette("Set1")
print(pal)
ax.stackplot(x, readV.values(),labels=readV.keys(), colors=[pal[2], pal[1], pal[4], pal[3]])

ax.legend(loc='lower left')
ax.set_xlabel('Round-trip time between sites [ms]')
ax.set_ylabel('Reads that returned version k [%] (1 = latest)')

plt.savefig('readV_freshness_netLatency_400.png')
plt.close()