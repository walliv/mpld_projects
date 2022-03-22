----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY uart_tx_block IS
    PORT(
      CLK                 : IN  STD_LOGIC;
      UART_TX_START       : IN  STD_LOGIC;
      UART_CLK_EN         : IN  STD_LOGIC;
      UART_DATA_IN        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      UART_TX_BUSY        : OUT STD_LOGIC;
      UART_TX_DATA_OUT    : OUT STD_LOGIC
    );
END uart_tx_block;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF uart_tx_block IS
----------------------------------------------------------------------------------

    type uart_tx_state_type is (IDLE, WAIT_EN, ST_START_B, ST_STOP_0);
    signal swch_pst : swch_state_type := IDLE;
    signal swch_nst : swch_state_type := IDLE;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

    uart_tx_fsm_pst_r : process( clk )
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
                    swch_nst <= WAIT_EN;
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
END architecture;
----------------------------------------------------------------------------------
