----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------
entity UART_TX_BLOCK is
    port(
        CLK              : in  std_logic;
        UART_TX_START    : in  std_logic;
        UART_CLK_EN      : in  std_logic;
        UART_DATA_IN     : in  std_logic_vector(7 downto 0);
        UART_TX_BUSY     : out std_logic;
        UART_TX_DATA_OUT : out std_logic
        );
end entity;
----------------------------------------------------------------------------------
architecture FULL of UART_TX_BLOCK is
----------------------------------------------------------------------------------

    type uart_tx_state_type is (IDLE, WAIT_EN, ST_START_B, ST_STOP_0);
    signal swch_pst : swch_state_type := IDLE;
    signal swch_nst : swch_state_type := IDLE;

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------

    uart_tx_fsm_pst_r : process(clk)
    begin
        if (rising_edge(clk)) then
            swch_pst <= swch_nst;
        end if;
    end process;

    uart_nst_logic : process (all)
    begin
        case swch_pst is
            when IDLE =>

                if (UART_TX_START = '1') then
                    swch_nst     <= WAIT_EN;
                    UART_TX_BUSY <= '1';
                end if;

            when WAIT_EN =>

                if (UART_CLK_EN = '1') then



                end if;

            when ST_START_B =>

            when ST_STOP_0 =>

        end case;

    end process;



----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
