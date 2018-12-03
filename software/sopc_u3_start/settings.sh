#-----------------------------------------------------
# Filename: settings.sh
# Author  : michael.pichler@fhnw.ch
# Date    : 10.05.2014
# Content : This setting-scripts will be read from q_flow
#-----------------------------------------------------

# Manually Edited Project Settings
# -------------------------------------------------------------------
QSYS_NAME=system
QHW_NAME=de1_soc_top
QSW_NAME=de1_soc_board_diag
BSP_TYPE=hal

FLASH_BASE=0x800000
FLASH_END=0xBFFFFF
CPU_RESET=0x800000

# Automatically Generated Project Settings
# -------------------------------------------------------------------
SOC_HOME=`pwd`
SOPC_FILE=${SOC_HOME}/4_quartus/${QHW_NAME}/${QSYS_NAME}.sopcinfo
CPU_NAME=""
BSP_DIR=${QSW_NAME}/bsp
APP_DIR=${QSW_NAME}/app
if [ -f 5_software/${QSW_NAME}/source/my_bsp.tcl ]; then
  BSP_ARGS="--script ${QSW_NAME}/source/my_bsp.tcl"
else
  BSP_ARGS=""
fi
