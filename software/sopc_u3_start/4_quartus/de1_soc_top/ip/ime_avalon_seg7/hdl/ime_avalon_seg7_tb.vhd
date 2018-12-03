--------------------------------------------------------------------------------
-- Filename: ime_avalon_seg7_tb.vhd
-- Author  : M. Pichler
-- Date    : 14.11.2008
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ime_avalon_seg7_tb IS
END ENTITY ime_avalon_seg7_tb;

ARCHITECTURE rtl OF ime_avalon_seg7_tb IS
  -------------------------------------------------------------------------------
  -- Components         
  -------------------------------------------------------------------------------
  COMPONENT ime_avalon_seg7 IS
    PORT(
      -- Avalon Clock & Reset Interface
      csi_clk       : IN  std_logic;
      rsi_reset_n   : IN  std_logic;
      -- Avalon-MM Interface / Slave Port
      avs_write     : IN  std_logic;
      avs_writedata : IN  std_logic_vector(31 DOWNTO 0);
      -- Avalon Conduit Interface
      coe_seg5      : OUT std_logic_vector(6 DOWNTO 0);
      coe_seg4      : OUT std_logic_vector(6 DOWNTO 0);
      coe_seg3      : OUT std_logic_vector(6 DOWNTO 0);
      coe_seg2      : OUT std_logic_vector(6 DOWNTO 0);
      coe_seg1      : OUT std_logic_vector(6 DOWNTO 0);
      coe_seg0      : OUT std_logic_vector(6 DOWNTO 0)
      );
  END COMPONENT ime_avalon_seg7;
  ---------------------------------------------------------------------------
  -- Constants         
  ---------------------------------------------------------------------------
  CONSTANT C_RESET       : time    := 100 ns;
  CONSTANT C_CYCLE       : time    := 20 ns;
  ---------------------------------------------------------------------------
  -- Signals         
  ---------------------------------------------------------------------------
  -- Stimuli Control
  SIGNAL   end_sim       : boolean := false;
  SIGNAL   csi_clk       : std_logic;
  SIGNAL   rsi_reset_n   : std_logic;
  -- Avalon-MM Interface / Slave Port
  SIGNAL   avs_write     : std_logic;
  SIGNAL   avs_writedata : std_logic_vector(31 DOWNTO 0);
  -- 7-Seg Display
  SIGNAL   seg5          : std_logic_vector(6 DOWNTO 0);
  SIGNAL   seg4          : std_logic_vector(6 DOWNTO 0);
  SIGNAL   seg3          : std_logic_vector(6 DOWNTO 0);
  SIGNAL   seg2          : std_logic_vector(6 DOWNTO 0);
  SIGNAL   seg1          : std_logic_vector(6 DOWNTO 0);
  SIGNAL   seg0          : std_logic_vector(6 DOWNTO 0);
  -- Check
  SIGNAL   seg0_char     : character;
  
BEGIN

  -- 1. Reset Stimuli
  rsi_reset_n <= '0', '1' AFTER C_RESET;
  -- 2. Clock Stimuli
  csi_clk     <= '0'      AFTER 2 ns WHEN now < 1 ns ELSE
                 NOT csi_clk AFTER C_CYCLE/2 WHEN end_sim = false ELSE
                 'X';


  -- 3. Avalon Write
  p_ava_write : PROCESS
  BEGIN
    avs_write     <= '0';
    avs_writedata <= (OTHERS => '0');
    WAIT UNTIL rsi_reset_n = '1';
    l_value : FOR i IN 0 TO 15 LOOP
      WAIT UNTIL falling_edge(csi_clk);
      avs_write <= '1';
      l_display : FOR j IN 0 TO 7 LOOP
        avs_writedata(j*4+3 DOWNTO j*4) <= std_logic_vector(to_unsigned(i, 4));
      END LOOP l_display;
      WAIT UNTIL falling_edge(csi_clk);
      avs_write <= '0';
      WAIT UNTIL falling_edge(csi_clk);
    END LOOP l_value;
    WAIT FOR 5*C_CYCLE;
    end_sim <= true;
    WAIT;
  END PROCESS p_ava_write;

  -- 4. DUV
  i0_duv : ime_avalon_seg7
    PORT MAP(
      -- Avalon Clock & Reset Interface
      csi_clk       => csi_clk,
      rsi_reset_n   => rsi_reset_n,
      -- Avalon-MM Interface / Slave Por
      avs_write     => avs_write,
      avs_writedata => avs_writedata,
      -- Avalon Conduit Interface
      coe_seg5      => seg5,
      coe_seg4      => seg4,
      coe_seg3      => seg3,
      coe_seg2      => seg2,
      coe_seg1      => seg1,
      coe_seg0      => seg0
      );
      
  -- 5. Check
  WITH seg0 SELECT 
    --                     gfedcba
    seg0_char <= '0' WHEN "1000000",
                 '1' WHEN "1111001",
                 '2' WHEN "0100100",
                 '3' WHEN "0110000",
                 '4' WHEN "0011001",
                 '5' WHEN "0010010",
                 '6' WHEN "0000010",
                 '7' WHEN "1111000",
                 '8' WHEN "0000000",
                 '9' WHEN "0010000",
                 'A' WHEN "0001000",
                 'B' WHEN "0000011",
                 'C' WHEN "1000110",
                 'D' WHEN "0100001",
                 'E' WHEN "0000110",
                 'F' WHEN "0001110",
                 '_' WHEN OTHERS;

END ARCHITECTURE rtl;
