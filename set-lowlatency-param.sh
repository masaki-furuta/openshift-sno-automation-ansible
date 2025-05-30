#!/bin/bash
cat <<EOF | sudo tee /etc/sysctl.d/99-lowlatency.conf
# Low latency kernel tuning

# Realtime scheduler unlimited runtime
kernel.sched_rt_runtime_us = -1

# Scheduler granularity (reduce for better latency)
kernel.sched_min_granularity_ns = 1000000
kernel.sched_latency_ns = 5000000

# VM: Reduce swap and dirty ratios for low latency
vm.swappiness = 1
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.dirty_expire_centisecs = 100

# Network: Increase backlog/buffers and enable low latency
net.core.netdev_max_backlog = 10000
net.core.rmem_max = 26214400
net.core.wmem_max = 26214400
net.ipv4.tcp_low_latency = 1

# (Optional) inotify - increase if needed
fs.inotify.max_user_watches = 1048576

EOF

sudo sysctl --system

