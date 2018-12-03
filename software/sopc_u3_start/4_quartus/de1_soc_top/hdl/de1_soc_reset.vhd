-- -----------------------------------------------------------------------------
-- Filename: de1_soc_reset.vhd
-- Author  : M. Pichler
-- Date    : 2014.01.28
-- Content : 
-- -----------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY de1_soc_reset IS
  GENERIC(
    G_MAX : natural := 64               -- delay for software reset
  );
  PORT(
    clk        : IN  std_ulogic;        -- clock
    pin_hw_rst : IN  std_ulogic;        -- hardware reset, active high
    pin_sw_rst : IN  std_ulogic;        -- software reset, active high
    pll_locked : IN  std_ulogic;        -- pll is stable
    -- 
    hw_rst_n   : OUT std_ulogic;        -- system reset, short pulse, active low
    sw_rst     : OUT std_ulogic         -- software reset, long pulse, active high
  );
END de1_soc_reset;

ARCHITECTURE rtl OF de1_soc_reset IS
  SIGNAL areset : std_ulogic;
BEGIN

  -- Reset Source
  -- areset <= '1' WHEN pin_hw_rst = '1' ELSE '1' WHEN pll_locked = '0' ELSE '0';
  areset <= '1' WHEN pin_hw_rst = '1' ELSE '0';

  -- Reset Generation
  p_reset : PROCESS(areset, clk)
    VARIABLE v_count : natural RANGE 0 TO G_MAX - 1;
  BEGIN
    IF areset = '1' THEN
      hw_rst_n <= '0';
      sw_rst   <= '1';
      v_count  := 0;
    ELSIF rising_edge(clk) THEN
      hw_rst_n <= '1';                  -- release hardware reset synchronous
      IF pin_sw_rst = '1' THEN
        sw_rst  <= '1';
        v_count := 0;
      ELSE
        IF v_count = G_MAX - 1 THEN
          sw_rst <= '0';                -- release software reset delayed
        ELSE
          v_count := v_count + 1;
        END IF;
      END IF;
    END IF;
  END PROCESS p_reset;

END rtl;
