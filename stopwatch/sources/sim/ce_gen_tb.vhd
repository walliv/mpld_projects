----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity ce_gen_tb is
end ce_gen_tb;
----------------------------------------------------------------------------------
architecture Behavioral of ce_gen_tb is
----------------------------------------------------------------------------------

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

  ce_gen_i : ce_gen
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
end Behavioral;
----------------------------------------------------------------------------------
