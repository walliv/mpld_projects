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

    type uart_tx_state_type is (IDLE, ST_DATA);
    signal uart_tx_pst : uart_tx_state_type := IDLE;
    signal uart_tx_nst : uart_tx_state_type := IDLE;

    signal data_load_pst : std_logic_vector((UART_DATA_IN'high + 2) downto 0) := (others => '1');
    signal data_load_nst : std_logic_vector((UART_DATA_IN'high + 2) downto 0) := (others => '1');
    signal data_cntr_pst : unsigned(4 downto 0)                               := (others => '0');
    signal data_cntr_nst : unsigned(4 downto 0)                               := (others => '0');

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------

    uart_tx_fsm_pst_r : process(clk)
    begin
        if (rising_edge(clk)) then
            uart_tx_pst <= uart_tx_nst;

            data_load_pst <= data_load_nst;
            data_cntr_pst <= data_cntr_nst;
        end if;
    end process;

    uart_nst_logic : process (all)
    begin

        uart_tx_nst   <= uart_tx_pst;
        data_load_nst <= data_load_pst;
        data_cntr_nst <= data_cntr_pst;

        UART_TX_BUSY <= '0';

        case uart_tx_pst is
            when IDLE =>

                if (UART_TX_START = '1') then

                    uart_tx_nst   <= ST_DATA;
                    data_load_nst <= UART_DATA_IN & "01";
                    data_cntr_nst <= (others => '0');

                    UART_TX_BUSY <= '1';

                end if;

            when ST_DATA =>

                UART_TX_BUSY <= '1';

                if (UART_CLK_EN = '1') then

                    data_load_nst <= '1' & data_load_pst(9 downto 1);
                    data_cntr_nst <= data_cntr_pst + 1;

                    if (data_cntr_pst >= 10) then
                        uart_tx_nst <= IDLE;
                    end if;

                end if;

        end case;

    end process;

    UART_TX_DATA_OUT <= data_load_pst(0);

----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
