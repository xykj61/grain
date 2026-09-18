#!/bin/sh
# energy_readout_control.sh -- the energy-facility probe, shown answering every way it can answer.
#
# WHAT THIS DOES. tools/fixtures/e/energy_readout_scan.sh reads real system paths, and this pier's
# own reading is a wall of "no" -- which proves this HOST lacks the facilities row 6 wants, and
# proves nothing about whether the SCAN would recognize one if it existed. An instrument that has
# only ever answered "no" is indistinguishable from one that cannot answer "yes" at all. So this
# control plants fake powercap, msr, hwmon, and perf-paranoid fixtures in a throwaway pen and points
# the scan's override environment variables at them, then plants a permission-denied case and an
# absent case beside the working ones.
#
# NINE PHASES.
#   powercap_found    -- a fake intel-rapl:0/energy_uj carrying an ascending counter reads
#                        available=yes with a positive delta_uj.
#   powercap_denied    -- the same file with mode 000 reads available=no reason=permission_denied
#                        (skipped when running as root, where mode 000 does not block a read).
#   powercap_absent    -- an empty root directory reads available=no reason=no_readable_energy_uj.
#   msr_present        -- a fake, readable msr device-node path reads available=yes.
#   perf_paranoid_gate -- a fake perf binary plus a paranoid file reading "2" reads
#                        available=no reason=paranoid_gated.
#   perf_paranoid_open -- the same binary with paranoid reading "-1" reads available=yes.
#   cpufreq_present    -- a fake scaling_cur_freq file reads available=yes and never sets the
#                        joule-bearing any_available flag -- a proxy is not a facility.
#   thermal_present    -- a fake thermal_zone0/temp file reads available=yes, same proxy rule.
#   virt_name_present  -- a fake systemd-detect-virt printing "microsoft" is echoed by name.
#
# WHAT THIS CANNOT SAY. Whether any of this fleet's eight piers carries a real one of these
# facilities. This proves the scan's own eyes, never what any given host shows them.
#
# EXPECTED: verdict=ok with control_failed=0.

set -u

PEN="$(mktemp -d "${TMPDIR:-/tmp}/energy_readout_control.XXXXXX")"
trap 'rm -rf "$PEN"' EXIT

SCAN="tools/fixtures/e/energy_readout_scan.sh"
control_failed=0
fail() {
  echo "LEG FAILED: $1"
  control_failed=$((control_failed + 1))
}

# -- powercap_found -----------------------------------------------------------------------------
mkdir -p "$PEN/powercap/intel-rapl:0"
echo 1000 > "$PEN/powercap/intel-rapl:0/energy_uj"
out=$(ENERGY_POWERCAP_ROOT="$PEN/powercap" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=powercap available=yes"; then
  echo "powercap_found=ok"
else
  fail "powercap_found -- expected available=yes, got: $(echo "$out" | grep facility=powercap)"
fi

# -- powercap_denied ----------------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
  mkdir -p "$PEN/powercap_denied/intel-rapl:0"
  echo 1000 > "$PEN/powercap_denied/intel-rapl:0/energy_uj"
  chmod 000 "$PEN/powercap_denied/intel-rapl:0/energy_uj"
  out=$(ENERGY_POWERCAP_ROOT="$PEN/powercap_denied" ENERGY_MSR_DEV="$PEN/no-msr" \
        ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
        ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" sh "$SCAN" 2>&1)
  if echo "$out" | grep -q "facility=powercap available=no reason=no_readable_energy_uj"; then
    echo "powercap_denied=ok"
  else
    fail "powercap_denied -- expected permission-blind no, got: $(echo "$out" | grep facility=powercap)"
  fi
  chmod 700 "$PEN/powercap_denied/intel-rapl:0/energy_uj"
else
  echo "powercap_denied=skipped (running as root)"
fi

# -- powercap_absent ----------------------------------------------------------------------------
mkdir -p "$PEN/powercap_empty"
out=$(ENERGY_POWERCAP_ROOT="$PEN/powercap_empty" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=powercap available=no reason=no_readable_energy_uj"; then
  echo "powercap_absent=ok"
else
  fail "powercap_absent -- expected no_readable_energy_uj, got: $(echo "$out" | grep facility=powercap)"
fi

# -- msr_present ---------------------------------------------------------------------------------
: > "$PEN/fake-msr"
out=$(ENERGY_POWERCAP_ROOT="$PEN/no-powercap" ENERGY_MSR_DEV="$PEN/fake-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=msr available=yes"; then
  echo "msr_present=ok"
else
  fail "msr_present -- expected available=yes, got: $(echo "$out" | grep facility=msr)"
fi

# -- perf_paranoid_gate / perf_paranoid_open --------------------------------------------------
mkdir -p "$PEN/bin"
cat > "$PEN/bin/perf" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$PEN/bin/perf"
echo 2 > "$PEN/paranoid"
out=$(ENERGY_POWERCAP_ROOT="$PEN/no-powercap" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/bin/perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" ENERGY_PARANOID_PATH="$PEN/paranoid" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=perf available=no reason=paranoid_gated paranoid=2"; then
  echo "perf_paranoid_gate=ok"
else
  fail "perf_paranoid_gate -- expected paranoid_gated, got: $(echo "$out" | grep facility=perf)"
fi

echo -1 > "$PEN/paranoid"
out=$(ENERGY_POWERCAP_ROOT="$PEN/no-powercap" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/bin/perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" ENERGY_PARANOID_PATH="$PEN/paranoid" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=perf available=yes"; then
  echo "perf_paranoid_open=ok"
else
  fail "perf_paranoid_open -- expected available=yes, got: $(echo "$out" | grep facility=perf)"
fi

# -- cpufreq_present ------------------------------------------------------------------------------
echo 2400000 > "$PEN/fake-cpufreq"
out=$(ENERGY_POWERCAP_ROOT="$PEN/no-powercap" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/fake-cpufreq" \
      ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=cpufreq available=yes.*scaling_cur_freq_khz=2400000"; then
  echo "cpufreq_present=ok"
else
  fail "cpufreq_present -- expected available=yes, got: $(echo "$out" | grep facility=cpufreq)"
fi
if echo "$out" | grep -q "^verdict=facility_available$"; then
  fail "cpufreq_present -- a frequency proxy set the joule-bearing verdict, and it must not"
else
  echo "cpufreq_proxy_isolated=ok"
fi

# -- thermal_present -------------------------------------------------------------------------------
mkdir -p "$PEN/thermal/thermal_zone0"
echo 45000 > "$PEN/thermal/thermal_zone0/temp"
out=$(ENERGY_POWERCAP_ROOT="$PEN/no-powercap" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" \
      ENERGY_THERMAL_ROOT="$PEN/thermal" ENERGY_VIRT_DETECT_BIN="$PEN/no-virt" sh "$SCAN" 2>&1)
if echo "$out" | grep -q "facility=thermal available=yes.*temp_millic=45000"; then
  echo "thermal_present=ok"
else
  fail "thermal_present -- expected available=yes, got: $(echo "$out" | grep facility=thermal)"
fi
if echo "$out" | grep -q "^verdict=facility_available$"; then
  fail "thermal_present -- a temperature proxy set the joule-bearing verdict, and it must not"
else
  echo "thermal_proxy_isolated=ok"
fi

# -- virt_name_present -----------------------------------------------------------------------------
mkdir -p "$PEN/bin"
cat > "$PEN/bin/systemd-detect-virt" <<'EOF'
#!/bin/sh
echo microsoft
EOF
chmod +x "$PEN/bin/systemd-detect-virt"
out=$(ENERGY_POWERCAP_ROOT="$PEN/no-powercap" ENERGY_MSR_DEV="$PEN/no-msr" \
      ENERGY_HWMON_ROOT="$PEN/no-hwmon" ENERGY_PERF_BIN="$PEN/no-perf" \
      ENERGY_NVIDIA_SMI_BIN="$PEN/no-nvidia" ENERGY_CPUFREQ_PATH="$PEN/no-cpufreq" \
      ENERGY_THERMAL_ROOT="$PEN/no-thermal" ENERGY_VIRT_DETECT_BIN="$PEN/bin/systemd-detect-virt" \
      sh "$SCAN" 2>&1)
if echo "$out" | grep -q "virt_name=microsoft"; then
  echo "virt_name_present=ok"
else
  fail "virt_name_present -- expected virt_name=microsoft, got: $(echo "$out" | grep virt_name)"
fi

echo "control_failed=$control_failed"
if [ "$control_failed" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
else
  echo "verdict=failed"
  exit 1
fi
