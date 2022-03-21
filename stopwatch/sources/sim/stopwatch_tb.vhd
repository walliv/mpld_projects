----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity STOPWATCH_TB is
end entity;
----------------------------------------------------------------------------------
architecture BEHAVIORAL of STOPWATCH_TB is
----------------------------------------------------------------------------------

  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL ce_100Hz               : STD_LOGIC;
  SIGNAL cnt_enable             : STD_LOGIC := '0';
  SIGNAL cnt_reset              : STD_LOGIC := '0';
  SIGNAL cnt_0                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);

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

  stopwatch_i : entity work.STOPWATCH
  PORT MAP(
    CLK                         => clk,
    CE_100HZ                    => ce_100hz,
    CNT_ENABLE                  => cnt_enable,
    CNT_RESET                   => cnt_reset,
    CNT_0                       => cnt_0,
    CNT_1                       => cnt_1,
    CNT_2                       => cnt_2,
    CNT_3                       => cnt_3
  );

  --------------------------------------------------------------------------------

  ce_gen_i : entity work.CE_GEN
  GENERIC MAP(
    DIV_FACT                    => 10
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => cnt_reset,
    CE_IN                       => '1',
    CE_OUT                      => ce_100hz
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    cnt_enable  <= '0';
    cnt_reset   <= '0';
    ------------------------------------------------------------------------------
    -- reset of the counter
    ------------------------------------------------------------------------------
    WAIT FOR clk_period * 5;
    cnt_reset   <= '1';
    WAIT FOR clk_period * 2;
    cnt_reset   <= '0';
    ------------------------------------------------------------------------------
    -- place your own stimuli below
    ------------------------------------------------------------------------------

    wait for clk_period*10;
    cnt_enable <= '1';

    wait for clk_period*200;

    ------------------------------------------------------------------------------
    -- end of simulation
    ------------------------------------------------------------------------------
    WAIT UNTIL unsigned(cnt_3) = 4;
    wait until unsigned(cnt_3) = 0;
    wait for clk_period*200;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
