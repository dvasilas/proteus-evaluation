import matplotlib.pyplot as plt
import numpy as np

# r = [500.07527, 1000.00041,2000.12605,2500.32767,2999.35171,3500.61361,3956.37687,4250.66576,4501.44157,5123.96493,5517.40271,6164.26833,6668.97663,6841.86631]
# q0 = [1.33996,1.41188,1.55848,1.57982,1.65732,1.73805,1.95672,2.02859,2.31715,3.54958,5.31499,6.70572,7.80892,8.32559]
# q1 = [0.539,0.54511,0.63229,0.63272,0.68807,0.77033,0.81648,0.83516,0.92187,0.8869,0.70989,0.7172,0.74336,0.64069]
# q2 = [0.49788,0.5539,0.59829,0.74025,1.08043,1.51594,1.49176,1.88023,2.60421,3.08691,2.49921,2.36018,2.76065,3.34478]
# # q3 [ (40,40,40,40,40,40,40,40,40,40,40,40,40,40]
# q4 = [2.44131,2.35315,2.80036,3.52845,4.52223,5.22262,4.28149,4.53687,5.42349,5.25071,4.87007,4.46105,4.33556,4.54324]


f, ax = plt.subplots()

A = [1.33996,1.41188,1.55848,1.57982,1.65732,1.73805,1.95672,2.02859]
B = [0.539,0.54511,0.63229,0.63272,0.68807,0.77033,0.81648,0.83516]
C = [0.49788,0.5539,0.59829,0.74025,1.08043,1.51594,1.49176,1.88023]
D = [40,40,40,40,40,40,40,40]
E = [2.44131,2.35315,2.80036,3.52845,4.52223,5.22262,4.28149,4.53687]
AB = np.add(A, B).tolist()
ABC = np.add(AB, C).tolist()
ABCD = np.add(ABC, D).tolist()

X = range(8)
names = ['500', '1000', '2000', '2500', '3000', '3500', '4000', '4250']

ax.bar(X, A, color = 'b', label='notification server')
ax.bar(X, B, color = 'k', bottom = A, label='corpus driver')
ax.bar(X, C, color = 'm', bottom = AB, label='sum')
ax.bar(X, D, color = 'c', bottom = ABC, label='cross-site communication')
ax.bar(X, E, color = 'g', bottom = ABCD, label='join-MV')

handles, labels = ax.get_legend_handles_labels()
ax.legend(handles,labels=labels, loc='center left')
plt.xticks(X, names)
ax.set(xlabel='Throughput [requests/s]', ylabel='95-th %-ile update latency [ms]')

plt.savefig('fr_latency_throughput_breakdown.png')
plt.close()