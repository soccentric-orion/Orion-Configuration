# webconfig-manifest.bbappend — Orion board manifest selection (spec §3).
#
# This repo is Orion-only; board-specific data lives solely in the board
# manifest. `webconfig-manifest.bb` already defaults WEBCONFIG_BOARD_FILE to
# the real "orion.json", so no override is required to get a correct image.
# This bbappend exists for the one case that still needs a MACHINE-specific
# override: a future Orion board revision that ships a distinct manifest
# file under a different MACHINE name.
#
# Real ST STM32MP1 MACHINE name (Orion-OS default board, per its own docs):
WEBCONFIG_BOARD_FILE:stm32mp15-disco = "orion.json"

# Mirror the platform id into the daemon environment so the embedded
# compiled-in fallback manifest agrees with the installed one if the BSP file
# is ever missing (spec §3). This lives in a webconfigd.bbappend per machine:
#   WEBCONFIG_PLATFORM:stm32mp15-disco = "orion"
