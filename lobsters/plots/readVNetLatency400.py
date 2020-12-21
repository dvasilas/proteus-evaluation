import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

x = [0, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]
readV = {
    '1': [0.97688,0.95267,0.93228,0.88961,0.84557,0.81864,0.7742,0.73992,0.70562,0.67594,0.65111,0.6095,0.57583,0.55423,0.52503,0.49801,0.4723],
    '2': [0.02282,0.04617,0.06492,0.1034,0.14181,0.16386,0.19875,0.22373,0.24351,0.26583,0.27911,0.30151,0.31955,0.32377,0.34046,0.34903,0.35588],
    '3-4': [0.0003,0.00115,0.0028,0.00698,0.01257,0.01747,0.02691,0.03615,0.05058,0.05772,0.06874,0.0874,0.10187,0.11916,0.12977,0.14777,0.16356],
    '>4': [0,0,0,0.00001,0.00005,0.00003,0.00014,0.0002,0.00029,0.00052,0.00104,0.00159,0.00274,0.00284,0.00473,0.00519,0.00826],
}

f, ax = plt.subplots()

pal = sns.color_palette("Set1")
print(pal)
ax.stackplot(x, readV.values(),labels=readV.keys(), colors=[pal[2], pal[1], pal[4], pal[3]])

ax.legend(loc='lower left')
ax.set_xlabel('Round-trip time between sites')
ax.set_ylabel('Reads that returned version k [%] (0 = latest)')

plt.savefig('readV_freshness_netLatency_400.png')
plt.close()