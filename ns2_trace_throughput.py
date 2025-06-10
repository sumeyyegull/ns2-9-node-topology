import matplotlib.pyplot as plt

node_number = 7  # İnceleyeceğin düğüm numarası
bin_size = 1.0  # 1 saniyelik zaman dilimi

time_bins = []
throughputs = []

packets_in_bin = 0
current_bin = 0.0
pkt_size = 0

with open("trace.tr", "r") as f:
    for line in f:
        parts = line.strip().split()
        if len(parts) < 6:
            continue
        event = parts[0]
        time = float(parts[1])
        src_node = int(parts[2])
       
        # sadece "+" (gönderim) olaylarını ve doğru düğümden çıkanları al
        if event == "+" and src_node == node_number:
            pkt_size = int(parts[5])  # paket boyutu
            while time > current_bin + bin_size:
                throughput = packets_in_bin * pkt_size * 8 / bin_size / 1_000_000  # Mbps
                time_bins.append(current_bin)
                throughputs.append(throughput)
                packets_in_bin = 0
                current_bin += bin_size
            packets_in_bin += 1

    # son bin için throughput hesapla
    if packets_in_bin > 0:
        throughput = packets_in_bin * pkt_size * 8 / bin_size / 1_000_000
        time_bins.append(current_bin)
        throughputs.append(throughput)

# grafik çiz
plt.plot(time_bins, throughputs, marker='o')
plt.xlabel("Zaman (s)")
plt.ylabel("Throughput (Mbps)")
plt.title(f"Düğüm {node_number} çıkış throughput grafiği")
plt.grid(True)
plt.show()
