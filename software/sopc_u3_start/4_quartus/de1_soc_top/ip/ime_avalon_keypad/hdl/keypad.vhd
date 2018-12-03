--------------------------------------------------------------------------------
-- Filename: keypad.vhd
-- Author  : Tobias Klenke & Roman Sonder
-- Date    : 03.12.2018
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity num_kp is
    port ( 
    -- Avalon Clock & Reset Interface
    clk       : in  std_logic;
    reset_n   : in  std_logic;
    -- Avalon Conduit Interface
    row_val   : in  std_logic_vector (3 downto 1);
    row_idx   : out STD_LOGIC_VECTOR (4 downto 1);
    -- Avalon-MM Interface / Slave Port
    avs_read  : IN  std_logic;
    avs_readdata	: out std_logic_vector (4 downto 1);
    -- Avalon Interrupt Interface
    hit       : out STD_LOGIC
    );
end entity num_kp;

architecture behavioral of num_kp is
    constant row_idx_res      : std_logic_vector (3 downto 0)   := "1110";
    constant cv_res           : std_logic_vector (2 downto 0)   := "111";
    
    signal curr_row_idx       : std_logic_vector (3 downto 0)   := row_idx_res;
    signal CV1, CV2, CV3, CV4 : std_logic_vector (3 downto 1)   := cv_res;
    signal sw_value	          : std_logic_vector (4 downto 1);
begin
  
  p_decode : PROCESS(clk, reset_n)
  BEGIN
    IF reset_n = '0' THEN
      curr_row_idx <= row_idx_res;
      CV1          <= cv_res;
      CV2          <= cv_res;
      CV3          <= cv_res;
      CV4          <= cv_res;
    ELSIF rising_edge(clk) THEN
      case curr_row_idx is
        when "1110" =>
          CV1 <= row_val;
          curr_row_idx <= "1101";
        when "1101" =>
          CV2 <= row_val;
          curr_row_idx <= "1011";
        when "1011" =>
          CV3 <= row_val;
          curr_row_idx <= "0111";
        when "0111" =>
          CV4 <= row_val;
          curr_row_idx <= row_idx_res;
        when others =>
          curr_row_idx <= row_idx_res;
        END case;
		END IF;
  END PROCESS p_decode;
  
  out_proc: process (clk, reset_n)
  begin
  
    IF reset_n = '0' THEN
        hit <= '0';
    ELSIF rising_edge(clk) THEN
      if (CV1 = "111" AND CV2 = "111" AND CV3 = "111") then
        -- Do nothing
      else
        hit <= '1';
        if CV1(1) = '0' then sw_value <= X"1";
        elsif CV1(2) = '0' then sw_value <= X"2";
        elsif CV1(3) = '0' then sw_value <= X"3";
        elsif CV2(1) = '0' then sw_value <= X"4";
        elsif CV2(2) = '0' then sw_value <= X"5";
        elsif CV2(3) = '0' then sw_value <= X"6";
        elsif CV3(1) = '0' then sw_value <= X"7";
        elsif CV3(2) = '0' then sw_value <= X"8";
        elsif CV3(3) = '0' then sw_value <= X"9";
        elsif CV4(1) = '0' then sw_value <= X"A";
        elsif CV4(2) = '0' then sw_value <= X"0";
        elsif CV4(3) = '0' then sw_value <= X"B";
        else hit <= '0'; sw_value <= X"B";
        end if;
      end if;
		END IF;
    
  end process;
  
  out_value_proc: process (avs_read)
  begin
  
    IF rising_edge(avs_read) THEN
      avs_readdata <= sw_value;
    ELSIF rising_edge(avs_read) THEN
      hit <= '0';
		END IF;
    
  end process;
  
  row_idx <= curr_row_idx;    
    
end architecture behavioral;