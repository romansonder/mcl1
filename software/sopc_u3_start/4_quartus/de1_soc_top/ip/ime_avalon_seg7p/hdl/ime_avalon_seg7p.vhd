--------------------------------------------------------------------------------
-- Filename: ime_avalon_seg7p.vhd
-- Author  : M. Pichler
-- Date    : 16.04.2014
-- Notes   : added Generic N
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ime_avalon_seg7p IS
  GENERIC(
    -- Choose between 1 and 8 Digits
    G_DIGITS      : natural RANGE 1 TO 8 := 8
    );
  PORT(
    -- Avalon Clock & Reset Interface
    csi_clk       : IN  std_logic;
    rsi_reset_n   : IN  std_logic;
    -- Avalon-MM Interface / Slave Port
    avs_write     : IN  std_logic;
    avs_writedata : IN  std_logic_vector(31 DOWNTO 0);
    -- Avalon Conduit Interface
    coe_hex       : OUT std_logic_vector(G_DIGITS*7-1 DOWNTO 0)
    );
END ENTITY ime_avalon_seg7p;

ARCHITECTURE rtl OF ime_avalon_seg7p IS
  -------------------------------------------------------------------------------
  -- Components         
  -------------------------------------------------------------------------------
  COMPONENT seg7_lut
    PORT(
      idig : IN  std_logic_vector(3 DOWNTO 0);
      oseg : OUT std_logic_vector(6 DOWNTO 0)
      );
  END COMPONENT seg7_lut;
  ---------------------------------------------------------------------------
  -- Constants         
  ---------------------------------------------------------------------------
  CONSTANT NR_OF_DIGITS : natural RANGE 1 TO G_DIGITS := G_DIGITS;
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  TYPE     oseg_type IS ARRAY(integer RANGE <>) OF std_logic_vector(6 DOWNTO 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  SIGNAL   digit_reg    : std_logic_vector(31 DOWNTO 0);
  SIGNAL   oseg         : oseg_type(1 TO NR_OF_DIGITS);

BEGIN

  -- 1. Avalon-MM intercace
  register_proc : PROCESS(csi_clk, rsi_reset_n)
  BEGIN
    IF rsi_reset_n = '0' THEN
      digit_reg <= (OTHERS => '0');
    ELSIF rising_edge(csi_clk) THEN
      IF avs_write = '1' THEN
        digit_reg <= avs_writedata;
      END IF;
    END IF;
  END PROCESS register_proc;

  -- 2. Component instantiation for each digit
  digit_gen : FOR i IN 1 TO NR_OF_DIGITS GENERATE
    digit_i0 : seg7_lut
      PORT MAP(
        idig => digit_reg((4 * i - 1) DOWNTO (4 * (i - 1))),
        oseg => coe_hex  ((7 * i - 1) DOWNTO (7 * (i - 1)))
        );
  END GENERATE digit_gen;
  
END ARCHITECTURE rtl;
