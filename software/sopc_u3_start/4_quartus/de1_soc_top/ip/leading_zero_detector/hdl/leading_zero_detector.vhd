--/**************************************************************************/
--/*      Copyright © 2004 Altera Corporation. All rights reserved.         */
--/* Altera products are protected under numerous U.S. and foreign patents, */
--/* maskwork rights, copyrights and other intellectual property laws.  This*/
--/* reference design file, and your use thereof, *is subject to and        */
--/* governed by the terms and conditions of the applicable Altera Reference*/
--/* Design License Agreement (either as signed by you or found at          */
--/* www.altera.com).  By using this reference design file, you indicate    */
--/* your acceptance of such terms and conditions between you and Altera    */
--/* Corporation.  In the event that you do not agree with such terms and   */
--/* conditions, you may not use the reference design file and please       */
--/* promptly destroy any copies you have made. This reference design file  */
--/* is being provided on an “as-is” basis and as an accommodation and      */
--/* therefore all warranties, representations or guarantees of any kind    */
--/* (whether express, implied or statutory) including, without limitation, */
--/* warranties of merchantability, non-infringement, or fitness for a      */
--/* particular purpose, are specifically disclaimed.  By making this       */
--/* reference design file available, Altera expressly does not recommend,  */
--/* suggest or require that this reference design file be used in          */
--/* combination with any other product not provided by Altera.             */
--/**************************************************************************/
library ieee;
use ieee.std_logic_1164.all;

entity leading_zero_detector is
  port (
    dataa : in  std_logic_vector(31 downto 0);
    result: out std_logic_vector(31 downto 0)
  );
end leading_zero_detector;

architecture rtl of leading_zero_detector is
  -- Signal Declarations
  signal result_wire: std_logic_vector(31 downto 0);

begin  
  
  -- Start Main Code       
  process (dataa)
  begin
	  if    dataa(31) = '1' then result_wire(4 downto 0) <= "00000";
	  elsif dataa(30) = '1' then result_wire(4 downto 0) <= "00001";
	  elsif dataa(29) = '1' then result_wire(4 downto 0) <= "00010";
	  elsif dataa(28) = '1' then result_wire(4 downto 0) <= "00011";
	  elsif dataa(27) = '1' then result_wire(4 downto 0) <= "00100";
	  elsif dataa(26) = '1' then result_wire(4 downto 0) <= "00101";
	  elsif dataa(25) = '1' then result_wire(4 downto 0) <= "00110";
	  elsif dataa(24) = '1' then result_wire(4 downto 0) <= "00111";
	  elsif dataa(23) = '1' then result_wire(4 downto 0) <= "01000";
	  elsif dataa(22) = '1' then result_wire(4 downto 0) <= "01001";
	  elsif dataa(21) = '1' then result_wire(4 downto 0) <= "01010";
	  elsif dataa(20) = '1' then result_wire(4 downto 0) <= "01011";
	  elsif dataa(19) = '1' then result_wire(4 downto 0) <= "01100";
	  elsif dataa(18) = '1' then result_wire(4 downto 0) <= "01101";
	  elsif dataa(17) = '1' then result_wire(4 downto 0) <= "01110";
	  elsif dataa(16) = '1' then result_wire(4 downto 0) <= "01111";
	  elsif dataa(15) = '1' then result_wire(4 downto 0) <= "10000";
	  elsif dataa(14) = '1' then result_wire(4 downto 0) <= "10001";
	  elsif dataa(13) = '1' then result_wire(4 downto 0) <= "10010";
	  elsif dataa(12) = '1' then result_wire(4 downto 0) <= "10011";
	  elsif dataa(11) = '1' then result_wire(4 downto 0) <= "10100";
	  elsif dataa(10) = '1' then result_wire(4 downto 0) <= "10101";
	  elsif dataa(9)  = '1' then result_wire(4 downto 0) <= "10110";
	  elsif dataa(8)  = '1' then result_wire(4 downto 0) <= "10111";
	  elsif dataa(7)  = '1' then result_wire(4 downto 0) <= "11000";
	  elsif dataa(6)  = '1' then result_wire(4 downto 0) <= "11001";
	  elsif dataa(5)  = '1' then result_wire(4 downto 0) <= "11010";
	  elsif dataa(4)  = '1' then result_wire(4 downto 0) <= "11011";
	  elsif dataa(3)  = '1' then result_wire(4 downto 0) <= "11100";
	  elsif dataa(2)  = '1' then result_wire(4 downto 0) <= "11101";
	  elsif dataa(1)  = '1' then result_wire(4 downto 0) <= "11110";
	  else                       result_wire(4 downto 0) <= "11111";
	  end if;
  end process;
	
  result <= "000000000000000000000000000" & result_wire(4 downto 0);
end rtl;