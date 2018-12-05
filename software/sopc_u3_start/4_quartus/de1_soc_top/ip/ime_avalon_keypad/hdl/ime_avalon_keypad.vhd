--------------------------------------------------------------------------------
-- Filename: keypad.vhd
-- Author  : Tobias Klenke & Roman Sonder & Samuel Wey
-- Date    : 03.12.2018
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY num_kp IS
    PORT ( 
    -- Avalon Clock & Reset Interface
    clk           : IN  STD_LOGIC;
    reset_n       : IN  STD_LOGIC;
    -- Avalon Conduit Interface
    row_val       : IN  STD_LOGIC_VECTOR (3 DOWNTO 1);
    row_idx       : OUT STD_LOGIC_VECTOR (4 DOWNTO 1);
    -- Avalon-MM Interface / Slave Port
    avs_read      : IN  STD_LOGIC;
    avs_readdata  : OUT STD_LOGIC_VECTOR (4 DOWNTO 1);
    -- Avalon Interrupt Interface
    hit           : OUT STD_LOGIC
    );
END ENTITY num_kp;

ARCHITECTURE behavioral OF num_kp IS
    CONSTANT row_idx_res      : STD_LOGIC_VECTOR (3 DOWNTO 0):= "1110";
    CONSTANT cv_res           : STD_LOGIC_VECTOR (2 DOWNTO 0):= "111";
    
    SIGNAL curr_row_idx       : STD_LOGIC_VECTOR (3 DOWNTO 0):= row_idx_res;
    SIGNAL CV1, CV2, CV3, CV4 : STD_LOGIC_VECTOR (3 DOWNTO 1):= cv_res;
    SIGNAL sw_value	          : STD_LOGIC_VECTOR (4 DOWNTO 1);
BEGIN
  
  p_decode : PROCESS(clk, reset_n)
  BEGIN
    IF reset_n = '0' THEN
      curr_row_idx <= row_idx_res;
      CV1          <= cv_res;
      CV2          <= cv_res;
      CV3          <= cv_res;
      CV4          <= cv_res;
    ELSIF rising_edge(clk) THEN
      CASE curr_row_idx IS
        WHEN "1110" =>
          CV1           <= row_val;
          curr_row_idx  <= "1101";
        WHEN "1101" =>
          CV2           <= row_val;
          curr_row_idx  <= "1011";
        WHEN "1011" =>
          CV3           <= row_val;
          curr_row_idx  <= "0111";
        WHEN "0111" =>
          CV4           <= row_val;
          curr_row_idx  <= row_idx_res;
        WHEN OTHERS =>
          curr_row_idx  <= row_idx_res;
        END CASE;
		END IF;
  END PROCESS p_decode;
  
  out_proc: PROCESS (clk, reset_n)
  BEGIN
  
    IF reset_n = '0' THEN
        hit <= '0';
    ELSIF rising_edge(clk) THEN
      IF (CV1 = "111" AND CV2 = "111" AND CV3 = "111") THEN
        -- Do nothing
      ELSE
        hit <= '1';
        IF CV1(1) = '0' THEN sw_value <= X"1";
        ELSIF CV1(2) = '0' THEN sw_value <= X"2";
        ELSIF CV1(3) = '0' THEN sw_value <= X"3";
        ELSIF CV2(1) = '0' THEN sw_value <= X"4";
        ELSIF CV2(2) = '0' THEN sw_value <= X"5";
        ELSIF CV2(3) = '0' THEN sw_value <= X"6";
        ELSIF CV3(1) = '0' THEN sw_value <= X"7";
        ELSIF CV3(2) = '0' THEN sw_value <= X"8";
        ELSIF CV3(3) = '0' THEN sw_value <= X"9";
        ELSIF CV4(1) = '0' THEN sw_value <= X"A";
        ELSIF CV4(2) = '0' THEN sw_value <= X"0";
        ELSIF CV4(3) = '0' THEN sw_value <= X"B";
        ELSE hit <= '0'; sw_value <= X"B";
        END IF;
      END IF;
		END IF;
    
  END PROCESS;
  
  out_value_proc: PROCESS (avs_read)
  BEGIN
  
    IF rising_edge(avs_read) THEN
      avs_readdata <= sw_value;
    ELSIF rising_edge(avs_read) THEN
      hit <= '0';
		END IF;
    
  END PROCESS;
  
  row_idx <= curr_row_idx;
    
END ARCHITECTURE behavioral;