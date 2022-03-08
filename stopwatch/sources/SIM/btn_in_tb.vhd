----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity btn_in_tb is
end btn_in_tb;
----------------------------------------------------------------------------------
architecture Behavioral of btn_in_tb is
----------------------------------------------------------------------------------

  COMPONENT btn_in
  GENERIC(
    DEB_PERIOD                  : POSITIVE := 3
  );
  PORT(
    clk                         : IN  STD_LOGIC;
    ce                          : IN  STD_LOGIC;
    btn                         : IN  STD_LOGIC;
    btn_debounced               : OUT STD_LOGIC;
    btn_egde_pos                : OUT STD_LOGIC;
    btn_egde_neg                : OUT STD_LOGIC;
    btn_egde_any                : OUT STD_LOGIC
  );
  END COMPONENT btn_in;

  --------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC (
    DIV_FACT                    : POSITIVE := 2       -- clock division factor
  );
  PORT (
    CLK                         : IN  STD_LOGIC;      -- clock signal
    SRST                        : IN  STD_LOGIC;      -- synchronous reset
    CE_IN                       : IN  STD_LOGIC;      -- input clock enable
    CE_OUT                      : OUT STD_LOGIC       -- clock enable output
  );
  END COMPONENT ce_gen;

  --------------------------------------------------------------------------------

  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL clk                    : STD_LOGIC := '0';
  SIGNAL ce                     : STD_LOGIC;
  SIGNAL btn                    : STD_LOGIC := '0';
  SIGNAL btn_debounced          : STD_LOGIC;
  SIGNAL btn_egde_pos           : STD_LOGIC;
  SIGNAL btn_egde_neg           : STD_LOGIC;
  SIGNAL btn_egde_any           : STD_LOGIC;

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

  ce_gen_i : ce_gen
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

  btn_in_i : btn_in
  GENERIC MAP(
    DEB_PERIOD                  => 5
  )
  PORT MAP(
    clk                         => clk,
    ce                          => ce,
    btn                         => btn,
    btn_debounced               => btn_debounced,
    btn_egde_pos                => btn_egde_pos,
    btn_egde_neg                => btn_egde_neg,
    btn_egde_any                => btn_egde_any
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    ------------------------------------------------------------------------------
    -- rising edge of the btn signal
    ------------------------------------------------------------------------------
    btn <= '0'; WAIT FOR clk_period *   8;
    btn <= '1'; WAIT FOR clk_period *  10;
    btn <= '0'; WAIT FOR clk_period *  10;
    btn <= '1'; WAIT FOR clk_period *  20;
    btn <= '0'; WAIT FOR clk_period *  20;
    btn <= '1'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- falling edge of the btn signal
    ------------------------------------------------------------------------------
    btn <= '0'; WAIT FOR clk_period *   8;
    btn <= '1'; WAIT FOR clk_period *  10;
    btn <= '0'; WAIT FOR clk_period *  10;
    btn <= '1'; WAIT FOR clk_period *  20;
    btn <= '0'; WAIT FOR clk_period * 200;
    ------------------------------------------------------------------------------
    -- end of simulation
    ------------------------------------------------------------------------------
    WAIT FOR clk_period * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------
