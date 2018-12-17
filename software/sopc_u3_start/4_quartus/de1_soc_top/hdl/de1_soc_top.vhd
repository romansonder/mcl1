-- -----------------------------------------------------------------------------
-- Filename: de1_soc_top.vhd
-- Author  : M. Pichler
-- Date    : 02.06.2010
-- Content : DE2-35 Toplevel with all Interfaces (achitecture struct)
--           Usage: 1. Remove all unused interfaces
--                  2. HDL Designer: Convert to Graphics
--                  3. Add/Design sub-blocks
-- -----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
USE work.de1_soc_pkg.ALL;

ENTITY de1_soc_top IS
  PORT(
    ---- Global Pins -----------------------------------------------------------
    clk_50    : IN    std_logic;        -- 50 MHz
    --clk_27      : IN    std_logic;                    -- 27 MHz
    --clk_ext     : IN    std_logic;                    -- External clock
    ---- Four Keys -------------------------------------------------------------
    key       : IN    std_logic_vector(3 DOWNTO 0);  -- Pushbutton[3:0]
    ---- 18 Switches -----------------------------------------------------------
    sw        : IN    std_logic_vector(9 DOWNTO 0);  -- Toggle switch[9:0]
    ---- 18 Red LEDs -----------------------------------------------------------
    ledr      : OUT   std_logic_vector(9 DOWNTO 0);  -- LED red[9:0]
    ---- Seven Seg Display -----------------------------------------------------
    hex0      : OUT   std_logic_vector(6 DOWNTO 0);  -- Seven segment digit 0
    hex1      : OUT   std_logic_vector(6 DOWNTO 0);  -- Seven segment digit 1
    hex2      : OUT   std_logic_vector(6 DOWNTO 0);  -- Seven segment digit 2
    hex3      : OUT   std_logic_vector(6 DOWNTO 0);  -- Seven segment digit 3
    hex4      : OUT   std_logic_vector(6 DOWNTO 0);  -- Seven segment digit 4
    hex5      : OUT   std_logic_vector(6 DOWNTO 0);  -- Seven segment digit 5
    ---- DRAM interface --------------------------------------------------------
    dram_addr  : OUT   std_logic_vector(12 DOWNTO 0); -- SDRAM address bus[11:0]
    dram_cas_n : OUT   std_logic;       -- SDRAM column address strobe
    dram_cke   : OUT   std_logic;       -- SDRAM clock enable
    dram_clk   : OUT   std_logic;       -- SDRAM clock
    dram_cs_n  : OUT   std_logic;       -- SDRAM chip select
    dram_dq    : INOUT std_logic_vector(15 DOWNTO 0); -- SDRAM data bus[15:0]
    dram_ras_n : OUT   std_logic;       -- SDRAM row address strobe
    dram_we_n  : OUT   std_logic;       -- SDRAM write enable
    dram_ba    : OUT   std_logic_vector(1 DOWNTO 0); -- SDRAM bank address[1:0]
    dram_dqm   : OUT   std_logic_vector(1 DOWNTO 0);  -- SDRAM data mask[1:0]
    -- keypad ---
    keypad_row_val             : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- row_val
    keypad_row_idx             : out   std_logic_vector(3 downto 0)
            
    ---- sd card Interface -----------------------------------------------------
    --sd_dat      : IN    std_logic;                      -- SD card data
    --sd_dat3     : IN    std_logic;                      -- SD card data 3
    --sd_cmd      : IN    std_logic;                      -- SD card command signal
    --sd_clk      : IN    std_logic;                      -- SD card clock
    ---- Ethernet Interface ----------------------------------------------------
    --enet_data   : INOUT std_logic_vector(15 DOWNTO 0);   -- DM9000A data bus[15:0]
    --enet_clk    : OUT   std_logic;                      -- DM9000A clock 25 mhz
    --enet_cmd    : OUT   std_logic;                      -- DM9000A cmd/data sel, 0=cmd
    --enet_cs_n   : OUT   std_logic;                      -- DM9000A chip select
    --enet_int    : IN    std_logic;                      -- DM9000A interrupt
    --enet_rd_n   : OUT   std_logic;                      -- DM9000A read
    --enet_wr_n   : OUT   std_logic;                      -- DM9000A write
    --enet_rst_n  : OUT   std_logic;                      -- DM9000A reset
    ---- UART ------------------------------------------------------------------
    --uart_rxd   : IN    std_logic;       -- UART receiver
    --uart_txd   : OUT   std_logic        -- UART transmitter
    ---- IRDA pins -------------------------------------------------------------
    --irda_txd    : OUT   std_logic;                      -- IRDA transmitter
    --irda_rxd    : IN    std_logic;                      -- IRDA receiver
    ---- PS2 interface ---------------------------------------------------------
    --ps2_clk     : IN    std_logic;                      -- PS2 clock
    --ps2_dat     : IN    std_logic;                      -- PS2 data
    ---- USB Interface ---------------------------------------------------------
    --otg_addr    : OUT   std_logic_vector(1 DOWNTO 0);   -- ISP1362 address[1:0]
    --otg_cs_n    : OUT   std_logic;                      -- ISP1362 chip select
    --otg_rd_n    : OUT   std_logic;                      -- ISP1362 read
    --otg_wr_n    : OUT   std_logic;                      -- ISP1362 write
    --otg_rst_n   : OUT   std_logic;                      -- ISP1362 reset
    --otg_data    : INOUT std_logic_vector(15 DOWNTO 0);   -- ISP1362 data bus[15:0]
    --otg_int0    : IN    std_logic;                      -- ISP1362 interrupt 0
    --otg_int1    : IN    std_logic;                      -- ISP1362 interrupt 1
    --otg_dack0_n : OUT   std_logic;                      -- ISP1362 dma acknowledge 0
    --otg_dack1_n : OUT   std_logic;                      -- ISP1362 dma acknowledge 1
    --otg_dreq0   : IN    std_logic;                      -- ISP1362 dma request 0
    --otg_dreq1   : IN    std_logic;                      -- ISP1362 dma request 1
    --otg_fspeed  : OUT   std_logic;                      -- USB full speed, 0=en., z=dis.
    --otg_lspeed  : OUT   std_logic;                      -- USB low speed,  0 =en.,z=dis.
    ---- Audio Codec Interface -------------------------------------------------
    --i2c_sclk    : OUT   std_logic;                      -- I2C clock
    --i2c_sdat    : INOUT std_logic;                       -- I2C data
    --aud_adclrck : OUT   std_logic;                      -- Audio codec adc lr clock
    --aud_adcdat  : IN    std_logic;                      -- Audio codec adc data
    --aud_daclrck : OUT   std_logic;                      -- Audio codec dac lr clock
    --aud_dacdat  : OUT   std_logic;                      -- Audio codec dac data
    --aud_xck     : OUT   std_logic;                      -- Audio codec chip clock
    --aud_bclk    : OUT   std_logic;                      -- Audio codec bit-stream clock
    ---- VGA Interface ---------------------------------------------------------
    --vga_r       : OUT   std_logic_vector(9 DOWNTO 0);   -- VGA red[9:0]
    --vga_g       : OUT   std_logic_vector(9 DOWNTO 0);   -- VGA green[9:0]
    --vga_b       : OUT   std_logic_vector(9 DOWNTO 0);   -- VGA blue[9:0]
    --vga_clk     : OUT   std_logic;                      -- VGA clock
    --vga_blank   : OUT   std_logic;                      -- VGA blank
    --vga_hs      : OUT   std_logic;                      -- VGA h_sync
    --vga_vs      : OUT   std_logic;                      -- VGA v_sync
    --vga_sync    : OUT   std_logic;                      -- VGA sync
    ---- TV Decoder ------------------------------------------------------------
    --td_reset    : OUT   std_logic;                      -- TV decoder reset
    --td_data     : IN    std_logic_vector(7 DOWNTO 0);   -- TV decoder data bus[7:0]
    --td_hs       : IN    std_logic;                      -- TV decoder h_sync
    --td_vs       : IN    std_logic;                      -- TV decoder v_sync
    ---- 2 x 36 GPIOs ----------------------------------------------------------
    --gpio_0      : INOUT std_logic_vector(35 DOWNTO 0);
    --gpio_1      : INOUT std_logic_vector(35 DOWNTO 0)
    );
END de1_soc_top;

ARCHITECTURE struct OF de1_soc_top IS

  -- Signal Declarations
  SIGNAL reset_n        : std_logic;    -- Asynchronous Reset
  SIGNAL cpu_reset      : std_logic;    -- Asynchronous CPU-Reset
  SIGNAL pll_locked     : std_logic;    -- Internal PLL has locked
  SIGNAL pll_reset      : std_logic;    -- PLL Reset
  SIGNAL cpu_resettaken : std_logic;    -- CPU-Reset was taken
  SIGNAL hex            : std_logic_vector(41 DOWNTO 0);  -- 6 HEX-Displays

BEGIN

  -- Reset Generator
  i0_de1_soc_reset : de1_soc_reset
    PORT MAP(
      clk        => clk_50,
      pin_hw_rst => sw(9),
      pin_sw_rst => sw(8),
      pll_locked => pll_locked,
      hw_rst_n   => reset_n,
      sw_rst     => cpu_reset
    );

  -- Status LED
  ledr(9) <= NOT reset_n;
  ledr(8) <= cpu_reset;

  -- Qsys-System
  i0_system : COMPONENT system
    PORT MAP(
      -- Globals
      clk_clk                => clk_50,
      reset_n_reset_n        => reset_n,
      pll_locked_export      => pll_locked,
      cpu_reset_cpu_resetrequest => cpu_reset,
      cpu_reset_cpu_resettaken   => cpu_resettaken,
      -- Memory/SRAM
      pll_dram_clk_clk       => dram_clk,
      dram_addr              => dram_addr,
      dram_ba                => dram_ba,
      dram_cas_n             => dram_cas_n,
      dram_cke               => dram_cke,
      dram_cs_n              => dram_cs_n,
      dram_dq                => dram_dq,
      dram_dqm               => dram_dqm,
      dram_ras_n             => dram_ras_n,
      dram_we_n              => dram_we_n,
      -- Control/KEY
      key_export             => key,
      -- Control/SWITCH
      sw_export              => sw(7 DOWNTO 0),
      -- Display/LEDR
      ledr_export            => ledr(7 DOWNTO 0),
      -- Keypad --
      keypad_row_val             => keypad_row_val,             --       keypad.row_val
      keypad_row_idx             => keypad_row_idx,             --             .row_idx
      keypad_export              => hex0,              --             .export
      -- Display/7-Segement
      hex_seg5               => hex5,
      hex_seg4               => hex4,
      hex_seg3               => hex3,
      hex_seg2               => hex2,
      hex_seg1               => hex1,
      hex_seg0               => open
      );

END struct;
