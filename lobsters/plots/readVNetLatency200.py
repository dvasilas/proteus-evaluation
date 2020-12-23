import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

x = [0, 10, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]
readV = {
    '1': [98.507,96.53,96.744,94.546,92.171,89.858,87.835,85.692,84.036,81.827,79.957,77.986,76.042,73.739,72.349,70.709,69.034],
    '2': [1.482,3.425,3.199,5.313,7.518,9.621,11.465,13.215,14.568,16.459,17.895,19.405,20.836,22.611,23.285,24.763,25.532],
    '3-4': [0.011,0.046,0.057,0.141,0.31,0.52,0.7,1.092,1.394,1.709,2.145,2.589,3.115,3.631,4.33,4.466,5.372],
    '>4': [0,0,0,0,0,0.002,0,0.001,0.003,0.005,0.003,0.021,0.006,0.019,0.035,0.062,0.062],
}

f, ax = plt.subplots()

pal = sns.color_palette("Set1")
print(pal)
ax.stackplot(x, readV.values(),labels=readV.keys(), colors=[pal[2], pal[1], pal[4], pal[3]])

ax.legend(loc='lower left')
ax.set_xlabel('Round-trip time between sites [ms]')
ax.set_ylabel('Queries that returned version k [%] (1 = latest)')

plt.savefig('readV_freshness_netLatency_200.png')
plt.close()