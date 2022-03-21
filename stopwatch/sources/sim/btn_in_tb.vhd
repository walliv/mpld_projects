----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity BTN_IN_TB is
end entity;
----------------------------------------------------------------------------------
architecture BEHAVIORAL of BTN_IN_TB is
----------------------------------------------------------------------------------

  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL ce                     : STD_LOGIC;
  SIGNAL btn_in                 : STD_LOGIC := '0';
  SIGNAL btn_debounced          : STD_LOGIC;
  SIGNAL btn_edge_pos           : STD_LOGIC;
  SIGNAL btn_edge_neg           : STD_LOGIC;
  SIGNAL btn_edge_any           : STD_LOGIC;

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
    DIV_FACT                    => 5
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE_IN                       => '1',
    CE_OUT                      => ce
  );

  --------------------------------------------------------------------------------

  btn_in_i : entity work.BTN_MGMT
  GENERIC MAP(
    DEB_PERIOD                  => 5
  )
  PORT MAP(
    clk                         => clk,
    ce                          => ce,
    btn_in                      => btn_in,
    btn_debounced               => btn_debounced,
    btn_edge_pos                => btn_edge_pos,
    btn_edge_neg                => btn_edge_neg,
    btn_edge_any                => btn_edge_any
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    ------------------------------------------------------------------------------
    -- rising edge of the btn signal
    ------------------------------------------------------------------------------
    btn_in <= '0'; WAIT FOR clk_period *   8;
    btn_in <= '1'; WAIT FOR clk_period *  10;
    btn_in <= '0'; WAIT FOR clk_period *  10;
    btn_in <= '1'; WAIT FOR clk_period *  20;
    btn_in <= '0'; WAIT FOR clk_period *  20;
    btn_in <= '1'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- falling edge of the btn signal
    ------------------------------------------------------------------------------
    btn_in <= '0'; WAIT FOR clk_period *   8;
    btn_in <= '1'; WAIT FOR clk_period *  10;
    btn_in <= '0'; WAIT FOR clk_period *  10;
    btn_in <= '1'; WAIT FOR clk_period *  20;
    btn_in <= '0'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- end of simulation
    ------------------------------------------------------------------------------
    WAIT FOR clk_period * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
