import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

x = [0, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]
readV = {
    '1': [0.98507,0.9653,0.94612,0.91008,0.87441,0.84115,0.80661,0.7711,0.74084,0.71413,0.68615,0.65515,0.63915,0.60851,0.59017,0.7013,0.69009],
    '2': [0.01482,0.03425,0.0525,0.08566,0.11747,0.14684,0.17383,0.20101,0.22362,0.2407,0.25799,0.27762,0.28496,0.3045,0.30802,0.2485,0.25512],
    '3-4': [0.00011,0.00046,0.00138,0.00426,0.00812,0.01199,0.01952,0.02774,0.03532,0.04488,0.05514,0.06641,0.0749,0.08529,0.09913,0.04973,0.0542],
    '>4': [0,0,0,0,0.00001,0.00002,0.00004,0.00014,0.00022,0.00029,0.00072,0.00082,0.00099,0.00169,0.00268,0.00047,0.00059],
}

f, ax = plt.subplots()

pal = sns.color_palette("Set1")
print(pal)
ax.stackplot(x, readV.values(),labels=readV.keys(), colors=[pal[2], pal[1], pal[4], pal[3]])

ax.legend(loc='lower left')
ax.set_xlabel('Round-trip time between sites')
ax.set_ylabel('Queries that returned version k [%] (0 = latest)')

plt.savefig('readV_freshness_netLatency_200.png')
plt.close()