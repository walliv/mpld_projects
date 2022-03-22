------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------------------------
entity UART_Tx_block_tb is
end UART_Tx_block_tb;
------------------------------------------------------------------------------------------------------------
architecture Behavioral of UART_Tx_block_tb is
------------------------------------------------------------------------------------------------------------

  COMPONENT UART_Tx_block
  PORT(
    clk                 : IN  STD_LOGIC;
    UART_Tx_start       : IN  STD_LOGIC;
    UART_clk_EN         : IN  STD_LOGIC;
    UART_Data_in        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    UART_Tx_busy        : OUT STD_LOGIC;
    UART_Tx_Data_out    : OUT STD_LOGIC
  );
  END COMPONENT;

------------------------------------------------------------------------------------------------------------

  component ce_gen
  generic (
    DIV_FACT            : positive := 2
  );
  port (
    clk                 : in  std_logic;
    srst                : in  std_logic;
    ce                  : in  std_logic;
    ce_o                : out std_logic
  );
  end component;

  ----------------------------------------------------------------------------------------------------------

  CONSTANT clk_period      : TIME := 20 ns;
  SIGNAL clk               : STD_LOGIC := '0';

  -- UUT inputs
  SIGNAL UART_Tx_start     : STD_LOGIC := '0';
  SIGNAL UART_Data_In      : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL UART_clk_EN       : STD_LOGIC;

  -- UUT outputs
  SIGNAL UART_Tx_Data_out  : STD_LOGIC;
  SIGNAL UART_Tx_busy      : STD_LOGIC;


------------------------------------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------------------------------------

  -- clk_gen
  clk_gen: PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR clk_period/2;
    clk <= '1';
    WAIT FOR clk_period/2;
  END PROCESS;

  ----------------------------------------------------------------------------------------------------------

  -- UART_Tx_block
  UART_Tx_block_i : UART_Tx_block
  PORT MAP(
    clk                 => CLK,
    UART_Tx_start       => UART_Tx_start,
    UART_clk_EN         => UART_clk_EN,
    UART_Data_In        => UART_Data_In,
    UART_Tx_Data_out    => UART_Tx_Data_out,
    UART_Tx_busy        => UART_Tx_busy
  );

  ----------------------------------------------------------------------------------------------------------

  -- clock enable generator
  ce_gen_i : ce_gen
  GENERIC MAP(
    DIV_FACT            => 20
  )
  PORT MAP(
    clk                 => CLK,
    srst                => '0',
    ce                  => '1',
    ce_o                => UART_clk_EN
  );

  ----------------------------------------------------------------------------------------------------------

  UART_Tx_stimuli: PROCESS
  BEGIN

    UART_Data_In  <= X"00";
    UART_Tx_start <= '0';
    WAIT FOR clk_period * 300;



    REPORT "================================================================" SEVERITY NOTE;
    REPORT "Simulation finished!" SEVERITY NOTE;
    REPORT "================================================================" SEVERITY FAILURE;
  END PROCESS;

---------------------------------------------------------------------------------
end Behavioral;
---------------------------------------------------------------------------------

