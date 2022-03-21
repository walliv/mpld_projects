----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity CE_GEN_TB is
end entity;
----------------------------------------------------------------------------------
architecture BEHAVIORAL of CE_GEN_TB is
----------------------------------------------------------------------------------

  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL srst                   : STD_LOGIC := '0';
  SIGNAL ce_in                  : STD_LOGIC := '0';
  SIGNAL ce_out                 : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS BEGIN
    clk <= '0'; WAIT FOR clk_period/2;
    clk <= '1'; WAIT FOR clk_period/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  ce_gen_i : entity work.CE_GEN
  GENERIC MAP(
    DIV_FACT                    => 10
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => srst,
    CE_IN                       => ce_in,
    CE_OUT                      => ce_out
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    srst  <= '1';
    ce_in <= '0';
    WAIT FOR clk_period * 5;
    srst  <= '0';
    WAIT FOR clk_period * 5;
    ce_in <= '1';
    WAIT FOR clk_period * 50;
    srst  <= '0';
    WAIT FOR clk_period * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
