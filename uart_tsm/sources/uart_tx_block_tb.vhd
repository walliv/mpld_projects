------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
------------------------------------------------------------------------------------------------------------
entity UART_Tx_block_tb is
end UART_Tx_block_tb;
------------------------------------------------------------------------------------------------------------
architecture BEHAVIORAL of UART_TX_BLOCK_TB is
------------------------------------------------------------------------------------------------------------

    component UART_TX_BLOCK
        port(
            CLK              : in  std_logic;
            UART_TX_START    : in  std_logic;
            UART_CLK_EN      : in  std_logic;
            UART_DATA_IN     : in  std_logic_vector(7 downto 0);
            UART_TX_BUSY     : out std_logic;
            UART_TX_DATA_OUT : out std_logic
            );
    end component;

------------------------------------------------------------------------------------------------------------

    component CE_GEN
        generic (
            DIV_FACT : positive := 2
            );
        port (
            CLK  : in  std_logic;
            SRST : in  std_logic;
            CE   : in  std_logic;
            CE_O : out std_logic
            );
    end component;

    ----------------------------------------------------------------------------------------------------------

    constant CLK_PERIOD : time      := 20 NS;
    signal clk          : std_logic := '0';

    -- UUT inputs
    signal uart_tx_start : std_logic                    := '0';
    signal uart_data_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal uart_clk_en   : std_logic;

    -- UUT outputs
    signal uart_tx_data_out : std_logic;
    signal uart_tx_busy     : std_logic;


------------------------------------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------------------------------------

    -- clk_gen
    clk_gen : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    ----------------------------------------------------------------------------------------------------------

    -- UART_Tx_block
    uart_tx_block_i : UART_TX_BLOCK
        port map(
            CLK              => clk,
            UART_TX_START    => uart_tx_start,
            UART_CLK_EN      => uart_clk_en,
            UART_DATA_IN     => uart_data_in,
            UART_TX_DATA_OUT => uart_tx_data_out,
            UART_TX_BUSY     => uart_tx_busy
            );

    ----------------------------------------------------------------------------------------------------------

    -- clock enable generator
    ce_gen_i : CE_GEN
        generic map(
            DIV_FACT => 20
            )
        port map(
            CLK  => clk,
            SRST => '0',
            CE   => '1',
            CE_O => uart_clk_en
            );

    ----------------------------------------------------------------------------------------------------------

    stim_p : process
    begin

        uart_data_in  <= X"00";
        uart_tx_start <= '0';
        wait for CLK_PERIOD * 300;

        uart_data_in <= x"69";
        uart_tx_start <= '1';
        wait for CLK_PERIOD;
        uart_tx_start <= '0';

        wait for CLK_PERIOD*2;
        wait until uart_tx_busy = '0';


        report "================================================================" severity NOTE;
        report "Simulation finished!" severity NOTE;
        report "================================================================" severity FAILURE;
        wait;
    end process;

---------------------------------------------------------------------------------
end architecture;
---------------------------------------------------------------------------------

