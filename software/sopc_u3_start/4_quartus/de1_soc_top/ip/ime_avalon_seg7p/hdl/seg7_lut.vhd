--------------------------------------------------------------------------------
-- Filename: seg7_lut.vhd
-- Author  : M. Pichler
-- Date    : 14.11.2008
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY seg7_lut IS
  PORT(
    idig : IN  std_logic_vector(3 DOWNTO 0);
    oseg : OUT std_logic_vector(6 DOWNTO 0)
    );
END ENTITY seg7_lut;


ARCHITECTURE rtl OF seg7_lut IS
-------------------------------------------------------------------------------
-- Constants                                                         
-------------------------------------------------------------------------------
  --                                               gfedcba
  CONSTANT C_X : std_logic_vector (6 DOWNTO 0) := "1110111";
  CONSTANT C_0 : std_logic_vector (6 DOWNTO 0) := "1000000";
  CONSTANT C_1 : std_logic_vector (6 DOWNTO 0) := "1111001";
  CONSTANT C_2 : std_logic_vector (6 DOWNTO 0) := "0100100";
  CONSTANT C_3 : std_logic_vector (6 DOWNTO 0) := "0110000";
  CONSTANT C_4 : std_logic_vector (6 DOWNTO 0) := "0011001";
  CONSTANT C_5 : std_logic_vector (6 DOWNTO 0) := "0010010";
  CONSTANT C_6 : std_logic_vector (6 DOWNTO 0) := "0000010";
  CONSTANT C_7 : std_logic_vector (6 DOWNTO 0) := "1111000";
  CONSTANT C_8 : std_logic_vector (6 DOWNTO 0) := "0000000";
  CONSTANT C_9 : std_logic_vector (6 DOWNTO 0) := "0010000";
  CONSTANT C_A : std_logic_vector (6 DOWNTO 0) := "0001000";
  CONSTANT C_B : std_logic_vector (6 DOWNTO 0) := "0000011";
  CONSTANT C_C : std_logic_vector (6 DOWNTO 0) := "1000110";
  CONSTANT C_D : std_logic_vector (6 DOWNTO 0) := "0100001";
  CONSTANT C_E : std_logic_vector (6 DOWNTO 0) := "0000110";
  CONSTANT C_F : std_logic_vector (6 DOWNTO 0) := "0001110";

BEGIN

  p_decod : PROCESS(idig)
  BEGIN
    CASE idig IS
      WHEN X"0"   => oseg <= C_0;
      WHEN X"1"   => oseg <= C_1;
      WHEN X"2"   => oseg <= C_2;
      WHEN X"3"   => oseg <= C_3;
      WHEN X"4"   => oseg <= C_4;
      WHEN X"5"   => oseg <= C_5;
      WHEN X"6"   => oseg <= C_6;
      WHEN X"7"   => oseg <= C_7;
      WHEN X"8"   => oseg <= C_8;
      WHEN X"9"   => oseg <= C_9;
      WHEN X"A"   => oseg <= C_A;
      WHEN X"B"   => oseg <= C_B;
      WHEN X"C"   => oseg <= C_C;
      WHEN X"D"   => oseg <= C_D;
      WHEN X"E"   => oseg <= C_E;
      WHEN X"F"   => oseg <= C_F;
      WHEN OTHERS => oseg <= C_X;
    END CASE;
  END PROCESS p_decod;

END ARCHITECTURE rtl;
