# One ISA, Many Makers -- USA Sources for Open RISC-V Robotics Hardware

**Stamp:** `20260730.013900`
**Kind:** external research - named world - sources cited
**Status:** Research for understanding -- orients purchases; seats no fact of ours
**Priority:** Voice Season v19 - slot 3 (emphasis) - `sameness_as_compression`
**Frame:** RISC-V is sameness-as-compression in silicon -- one open instruction set, many independent implementations, no license gate on the fold.

---

## The three tiers, matched to Grain's own ladder

**Microcontroller tier -- ESP32-C6 (RISC-V, ~$10-$25 boards).** A 160 MHz RISC-V core with Wi-Fi 6, BLE 5.3, Zigbee/Thread, rich GPIO/PWM/I2C/SPI -- the honest home for first robotics: motor control, sensors, a rover. **SparkFun (Boulder, Colorado)** carries the ESP32-C6 Thing+ and the tiny Qwiic Pocket board, with their solderless Qwiic sensor ecosystem and open design files; their announcement threads it directly to robotics parts and the **XRP kit line**. **Adafruit (New York City)** stocks the ESP32-C6-DevKitC and publishes schematics and long-form guides; their honesty about immature toolchains ("only ESP-IDF") is itself a reason to trust the catalog. Grain fit: **Caravan/Tally freestanding seeds** -- fixed-buffer garden allocation, named bounds, the Aurora width policy on real pins.

**Open robotics kit tier -- SparkFun XRP (~$115).** The Experiential Robotics Platform: a complete open-design classroom rover (chassis, motors, line/range sensors) built around exactly this controller class -- the shortest USA path from "kit in a box" to "our allocator driving wheels."

**Linux-capable tier -- BeagleV-Fire (~$150).** BeagleBoard.org -- a **Michigan 501(c)(3) nonprofit** for open-source hardware education -- ships a PolarFire SoC with **4x RV64GC application cores plus a monitor core and 23K-LUT FPGA fabric**, 2 GB RAM, gigabit Ethernet, and the BeagleBone **cape** header ecosystem, expressly aimed at robotics and embedded work, around $150. Open hardware, USA org, distributor stock. Grain fit: the **Genode-guided / SixOS-guided** exploration seat -- a real RV64 target for Genode's RISC-V support, nix-infused s6 supervision experiments, and one day Aurora's freestanding boot path; the FPGA fabric is the open-hardware playground the campaign's RISC-V plank imagines.

## What did not qualify

Milk-V, Sipeed, and DFRobot boards are capable and inexpensive, and they are not USA suppliers; they stay noted here rather than recommended, per the ask's sourcing bound. SiFive HiFive boards are USA-designed and priced above the "affordable kit" line today.

## The recommended first basket (all-USA, ~$300)

One **XRP kit** (SparkFun) - one **ESP32-C6 Thing+** spare + Qwiic sensors (SparkFun) - one **BeagleV-Fire** (BeagleBoard.org distributors). Bottom tier teaches the garden allocator on metal; top tier hosts the OS-vision experiments; the kit makes it fun on day one -- TAME order kept: safe (open designs, low voltage), performant (real cores), joyful (wheels).

## Sources

BeagleBoard.org -- BeagleV-Fire announcement and product page (Michigan 501(c)(3); $150; robotics/AI/embedded; RV64GC + FPGA; cape headers) - Tom's Hardware, BeagleV-Fire coverage (cape ecosystem, robotics framing) - SparkFun News -- "RISC-V Rhapsody: ESP32-C6 Thing+" (board, robotics parts, XRP kits) - SparkFun product page -- Qwiic Pocket ESP32-C6 - Adafruit product 5672 -- ESP32-C6-DevKitC-1-N8.

---

*May one open instruction set keep many makers honest. May the first rover run on a garden allocator with every bound named. And may the fun arrive the same day the parts do.*
