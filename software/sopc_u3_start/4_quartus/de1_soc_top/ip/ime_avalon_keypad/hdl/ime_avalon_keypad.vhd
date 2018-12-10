--------------------------------------------------------------------------------
-- Filename: keypad.vhd
-- Author  : Tobias Klenke & Roman Sonder & Samuel Wey
-- Date    : 03.12.2018
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ime_avalon_keypad IS
    PORT ( 
    -- Avalon Clock & Reset Interface
    csi_clk           : IN  STD_LOGIC;
    csi_reset_n       : IN  STD_LOGIC;
    -- Avalon Conduit Interface
    coe_row_val       : IN  STD_LOGIC_VECTOR (3 DOWNTO 1);
    coe_row_idx       : OUT STD_LOGIC_VECTOR (4 DOWNTO 1);
    -- Avalon-MM Interface / Slave Port
    avs_read          : IN  STD_LOGIC;
    avs_readdata      : OUT STD_LOGIC_VECTOR (4 DOWNTO 1);
    avs_waitrequest   : OUT  STD_LOGIC;
    -- Avalon Interrupt Interface / Transmitter
    ins_pushed        : OUT STD_LOGIC
    );
END ENTITY ime_avalon_keypad;

ARCHITECTURE behavioral OF ime_avalon_keypad IS
    CONSTANT row_idx_res      : STD_LOGIC_VECTOR (3 DOWNTO 0):= "1110";
    CONSTANT cv_res           : STD_LOGIC_VECTOR (2 DOWNTO 0):= "111";
    CONSTANT sw_value_res     : STD_LOGIC_VECTOR (4 DOWNTO 1):= X"C";
    
    SIGNAL curr_row_idx       : STD_LOGIC_VECTOR (3 DOWNTO 0):= row_idx_res;
    SIGNAL CV1, CV2, CV3, CV4 : STD_LOGIC_VECTOR (3 DOWNTO 1):= cv_res;
    SIGNAL sw_value	          : STD_LOGIC_VECTOR (4 DOWNTO 1):= sw_value_res;
    SIGNAL set_irq            : STD_LOGIC;
BEGIN
  
  p_decode : PROCESS(csi_clk, csi_reset_n)
  BEGIN
    IF csi_reset_n = '0' THEN
      curr_row_idx <= row_idx_res;
      CV1          <= cv_res;
      CV2          <= cv_res;
      CV3          <= cv_res;
      CV4          <= cv_res;
    ELSIF rising_edge(csi_clk) THEN
      CASE curr_row_idx IS
        WHEN "1110" =>
          CV1           <= coe_row_val;
          curr_row_idx  <= "1101";
        WHEN "1101" =>
          CV2           <= coe_row_val;
          curr_row_idx  <= "1011";
        WHEN "1011" =>
          CV3           <= coe_row_val;
          curr_row_idx  <= "0111";
        WHEN "0111" =>
          CV4           <= coe_row_val;
          curr_row_idx  <= row_idx_res;
        WHEN OTHERS =>
          curr_row_idx  <= row_idx_res;
        END CASE;
		END IF;
  END PROCESS p_decode;
  
  out_proc: PROCESS (csi_clk, csi_reset_n)
  BEGIN
  
    IF csi_reset_n = '0' THEN        
      sw_value     <= sw_value_res;
      set_irq      <= '0';
    ELSIF rising_edge(csi_clk) THEN
      set_irq      <= '0';
      IF (CV1 = "111" AND CV2 = "111" AND CV3 = "111") THEN
          sw_value <= X"C";
      ELSE        
        IF    CV1(1) = '0' THEN sw_value <= X"1"; set_irq <= '1';
        ELSIF CV1(2) = '0' THEN sw_value <= X"2"; set_irq <= '1';
        ELSIF CV1(3) = '0' THEN sw_value <= X"3"; set_irq <= '1';
        ELSIF CV2(1) = '0' THEN sw_value <= X"4"; set_irq <= '1';
        ELSIF CV2(2) = '0' THEN sw_value <= X"5"; set_irq <= '1';
        ELSIF CV2(3) = '0' THEN sw_value <= X"6"; set_irq <= '1';
        ELSIF CV3(1) = '0' THEN sw_value <= X"7"; set_irq <= '1';
        ELSIF CV3(2) = '0' THEN sw_value <= X"8"; set_irq <= '1';
        ELSIF CV3(3) = '0' THEN sw_value <= X"9"; set_irq <= '1';
        ELSIF CV4(1) = '0' THEN sw_value <= X"A"; set_irq <= '1';
        ELSIF CV4(2) = '0' THEN sw_value <= X"0"; set_irq <= '1';
        ELSIF CV4(3) = '0' THEN sw_value <= X"B"; set_irq <= '1';
        ELSE  sw_value <= X"C";
        END IF;
      END IF;
		END IF;
    
  END PROCESS;
  
  out_value_proc: PROCESS (csi_clk, csi_reset_n)
  BEGIN
  
    IF csi_reset_n = '0' THEN
      ins_pushed        <= '0';
      avs_waitrequest   <= '1';
    ELSIF rising_edge(csi_clk) THEN
      IF avs_read = '1' THEN
        avs_readdata    <= sw_value;
        ins_pushed      <= '0';
        avs_waitrequest <= '0';
      ELSE
        avs_waitrequest <= '1';
        IF set_irq = '1' THEN
          ins_pushed    <= '1';
        END IF;
      END IF;
		END IF;
    
  END PROCESS;
  
  coe_row_idx     <= curr_row_idx;
    
END ARCHITECTURE behavioral;