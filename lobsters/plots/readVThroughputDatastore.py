import numpy as np
from matplotlib import pyplot as plt

x =[500.00034,1000.00037,2000.02611,2499.95105,3000.05147,3501.33461,4026.1502,4251.92629]
readV = {
    '0': [0.99826,0.99567,0.99071,0.98734,0.98327,0.97732,0.95813,0.95453],
    '1': [0.00174,0.00433,0.00925,0.01256,0.01655,0.02229,0.04041,0.04389],
    '2-3': [0,0,0.00004,0.0001,0.00018,0.00039,0.00146,0.00158],
    '>=4': [0,0,0,0,0,0,0,0.00001],
}

f, ax = plt.subplots()

ax.stackplot(x, readV.values(),labels=readV.keys(), colors=['g', 'b', 'y', 'r'])

ax.legend(loc='lower left')
ax.set_xlabel('Throughput [requests/s]')
ax.set_ylabel('Queries that returned version k [%] (0 = latest)')

# plt.show()
plt.savefig('readV_freshness_throughput_datastore.png')
plt.close()