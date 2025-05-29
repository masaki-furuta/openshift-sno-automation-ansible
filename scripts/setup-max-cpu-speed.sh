#!/bin/bash

SERVICE_NAME=cpu-perf-fix
SCRIPT_PATH=/usr/local/bin/${SERVICE_NAME}.sh
SERVICE_PATH=/etc/systemd/system/${SERVICE_NAME}.service

# 1. 本体スクリプト作成
sudo tee "${SCRIPT_PATH}" > /dev/null <<'EOF'
#!/bin/bash
set -e
# governor/performance & min/max=3.8GHz (3800000kHz) を全コアに適用
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
  echo performance > $cpu/cpufreq/scaling_governor 2>/dev/null || true
  echo 3800000 > $cpu/cpufreq/scaling_min_freq 2>/dev/null || true
  echo 3800000 > $cpu/cpufreq/scaling_max_freq 2>/dev/null || true
done
EOF

sudo chmod +x "${SCRIPT_PATH}"

# 2. systemd unit 作成
sudo tee "${SERVICE_PATH}" > /dev/null <<EOF
[Unit]
Description=Set all CPUs to performance governor and 3.8GHz fixed
After=multi-user.target

[Service]
Type=oneshot
ExecStart=${SCRIPT_PATH}

[Install]
WantedBy=multi-user.target
EOF

# 3. 有効化
sudo systemctl daemon-reload
sudo systemctl enable --now "${SERVICE_NAME}.service"

echo "✅ ${SERVICE_PATH} と ${SCRIPT_PATH} を作成し、サービスを有効化しました。"

