--------------------------------------------------------------------------------
-- Filename: ime_avalon_keypad.vhd
-- Author  : Tobias Klenke & Roman Sonder
-- Date    : 03.12.2018
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ime_avalon_keypad IS
  PORT(
    -- Avalon Clock & Reset Interface
    csi_clk       : IN  std_logic;
    rsi_reset_n   : IN  std_logic;
    -- Avalon-MM Interface / Slave Port
    avs_read     : IN  std_logic;
    avs_readdata : IN  std_logic_vector(3 DOWNTO 0)
    );
END ENTITY ime_avalon_keypad;

ARCHITECTURE rtl OF ime_avalon_keypad IS
  -------------------------------------------------------------------------------
  -- Components         
  -------------------------------------------------------------------------------
  COMPONENT seg7_lut
    PORT(
      clk     : IN  std_logic;
      reset_n : IN  std_logic;
      idig    : IN  std_logic_vector(3 DOWNTO 0);
      oseg    : OUT std_logic_vector(6 DOWNTO 0)
      );
  END COMPONENT seg7_lut;
  ---------------------------------------------------------------------------
  -- Constants         
  ---------------------------------------------------------------------------
  CONSTANT NR_OF_DIGITS : integer RANGE 1 TO 8 := 6;
  ---------------------------------------------------------------------------
  -- Types         
  ---------------------------------------------------------------------------
  TYPE     oseg_type IS ARRAY(integer RANGE <>) OF std_logic_vector(6 DOWNTO 0);
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  SIGNAL   digit_reg    : std_logic_vector(31 DOWNTO 0);
  SIGNAL   oseg8        : oseg_type(1 TO NR_OF_DIGITS);

BEGIN

  -- 1. Avalon Write Register
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

  -- 2. Eight Displays
  digit_gen : FOR i IN 1 TO NR_OF_DIGITS GENERATE
    digit_i0 : seg7_lut
      PORT MAP(
        clk     => csi_clk,
        reset_n => rsi_reset_n,
        idig    => digit_reg((4 * i - 1) DOWNTO (4 * (i - 1))),
        oseg    => oseg8(i)
        );
  END GENERATE digit_gen;

  -- 3. Mapping to outputs
  coe_seg5 <= oseg8(6);
  coe_seg4 <= oseg8(5);
  coe_seg3 <= oseg8(4);
  coe_seg2 <= oseg8(3);
  coe_seg1 <= oseg8(2);
  coe_seg0 <= oseg8(1);
  
END ARCHITECTURE rtl;
