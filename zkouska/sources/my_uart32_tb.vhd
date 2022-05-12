------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

------------------------------------------------------------------------------------------------------------
entity UART_Tx_block_tb is
end UART_Tx_block_tb;
------------------------------------------------------------------------------------------------------------
architecture BEHAVIORAL of UART_TX_BLOCK_TB is
------------------------------------------------------------------------------------------------------------

    constant DATA_LENGTH : positive := 32;

    constant CLK_PERIOD : time      := 8 NS;
    signal clk          : std_logic := '0';

    -- UUT inputs
    signal uart_tx_start : std_logic                    := '0';
    signal uart_data_in  : std_logic_vector((DATA_LENGTH - 1) downto 0) := (others => '0');
    signal uart_clk_en   : std_logic;

    -- UUT outputs
    signal uart_tx_data_out : std_logic;
    signal uart_tx_busy     : std_logic;

    signal lfsr_uart_data : std_logic_vector((DATA_LENGTH - 1) downto 0);

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
    uart_tx_block_i : entity work.UART_TX_BLOCK
        generic map(
            DATA_LENGTH => DATA_LENGTH
        )
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
    ce_gen_i : entity work.CE_GEN
        generic map(
            DIV_FACT => 25
            )
        port map(
            CLK     => clk,
            SRST    => '0',
            CE_IN   => '1',
            CE_OUT  => uart_clk_en
            );

    ----------------------------------------------------------------------------------------------------------

    lfsr_gen_i : entity work.LFSR_SIMPLE_RANDOM_GEN
        generic map(
            DATA_WIDTH => 32
        )
        port map (
            CLK => clk,
            RESET => '0',
            ENABLE => uart_clk_en,
            DATA => lfsr_uart_data
        );

    stim_p : process
    begin

        uart_data_in  <= X"00000000";
        uart_tx_start <= '0';
        wait for CLK_PERIOD * 300;

        uart_data_in <= x"AAAA5555";
        uart_tx_start <= '1';
        wait for CLK_PERIOD;
        uart_tx_start <= '0';

        wait for CLK_PERIOD*2;
        wait until uart_tx_busy = '0';
        wait for CLK_PERIOD*50;

        uart_data_in <= x"FEFE4201";
        uart_tx_start <= '1';
        wait for CLK_PERIOD;
        uart_tx_start <= '0';

        -- unexpected change of the input
        wait for CLK_PERIOD*100;
        uart_data_in <= x"ABABABAB";
        uart_tx_start <= '1';
        wait for CLK_PERIOD;
        uart_tx_start <= '0';

        -- waits until transmission ends
        wait for CLK_PERIOD*2;
        wait until uart_tx_busy = '0';
        wait for CLK_PERIOD*50;

        for i in 1 to 100 loop

            uart_data_in <= lfsr_uart_data;
            uart_tx_start <= '1';
            wait for CLK_PERIOD;
            uart_tx_start <= '0';

            wait for CLK_PERIOD*2;
            wait until uart_tx_busy = '0';
            wait for CLK_PERIOD*20;

        end loop;

        wait for CLK_PERIOD*100;

        report "================================================================" severity NOTE;
        report "Simulation finished!" severity NOTE;
        report "================================================================" severity FAILURE;
        wait;
    end process;

---------------------------------------------------------------------------------
end architecture;
---------------------------------------------------------------------------------

