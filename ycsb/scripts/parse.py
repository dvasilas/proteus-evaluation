#!/usr/bin/env python3

import sys

def main():
    with open(sys.argv[1], "r") as fr:
        with open(sys.argv[2], "w") as fw:
            queryMeasurements = {}
            updateMeasurements = {}
            line = fr.readline()
            threads = False
            while line:
                if "threadcount" in line:
                    line = line.split("=")
                    line = line[1].strip()[1:-1]
                    fw.write("Threadcount: " + line + "\n")
                if not threads and "threads" in line:
                    threads = True
                    line = line.split("=")
                    line = line[1].strip()[1:-1]
                    fw.write("Threadcount: " + line + "\n")
                else:
                    line = line.strip().split(", ")
                if line[0] == "[QUERY]":
                    queryMeasurements[line[1]] = line[2]
                if line[0] == "[UPDATE]":
                    updateMeasurements[line[1]] = line[2]
            
                line = fr.readline()

            fw.write("[QUERY] Throughput: " + queryMeasurements["Throughput(ops/sec)"] + "\n")
            fw.write("[QUERY] AverageLatency: " + str(float(queryMeasurements["AverageLatency(us)"]) / 1000) + "\n")
            fw.write("[QUERY] 50thPercentileLatency: " + str(float(queryMeasurements["50thPercentileLatency(us)"]) / 1000) + "\n")
            fw.write("[QUERY] 90thPercentileLatency: " + str(float(queryMeasurements["90thPercentileLatency(us)"]) / 1000) + "\n")
            fw.write("[QUERY] 95thPercentileLatency: " + str(float(queryMeasurements["95thPercentileLatency(us)"]) / 1000) + "\n")
            fw.write("[QUERY] 99thPercentileLatency: " + str(float(queryMeasurements["99thPercentileLatency(us)"]) / 1000) + "\n")


            fw.write("[UPDATE] Throughput: " + updateMeasurements["Throughput(ops/sec)"] + "\n")
            fw.write("[UPDATE] AverageLatency: " + str(float(updateMeasurements["AverageLatency(us)"]) / 1000) + "\n")
            fw.write("[UPDATE] 50thPercentileLatency: " + str(float(updateMeasurements["50thPercentileLatency(us)"]) / 1000) + "\n")
            fw.write("[UPDATE] 90thPercentileLatency: " + str(float(updateMeasurements["90thPercentileLatency(us)"]) / 1000) + "\n")
            fw.write("[UPDATE] 95thPercentileLatency: " + str(float(updateMeasurements["95thPercentileLatency(us)"]) / 1000) + "\n")
            fw.write("[UPDATE] 99thPercentileLatency: " + str(float(updateMeasurements["99thPercentileLatency(us)"]) / 1000) + "\n")

if __name__ == "__main__":
    main()
