-- stopwatch_fsm.vhd: this component establishes the FSM which is used for the overall controll of the design
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity STOPWATCH_FSM is

    port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        BTN_START   : in  std_logic;
        BTN_LAP     : in  std_logic;
        CNT_RESET   : out std_logic;
        CNT_ENABLE  : out std_logic;
        DISP_ENABLE : out std_logic);

end entity;

architecture FULL of STOPWATCH_FSM is

    type swch_state_type is (IDLE, RUN, LAP, REFRESH, CNTR_STOP);
    signal swch_pst : swch_state_type := IDLE;
    signal swch_nst : swch_state_type := IDLE;

begin

    pst_reg_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                swch_pst <= IDLE;
            else
                swch_pst <= swch_nst;
            end if;
        end if;
    end process;

    nst_logic_p : process (all) is
    begin

        swch_nst    <= swch_pst;
        CNT_RESET   <= '0';
        CNT_ENABLE  <= '0';
        DISP_ENABLE <= '0';

        case swch_pst is
            when IDLE =>

                CNT_RESET   <= '1';
                DISP_ENABLE <= '1';

                if (BTN_START = '1' and BTN_LAP = '0') then
                    swch_nst <= RUN;
                end if;

            when RUN =>

                CNT_ENABLE  <= '1';
                DISP_ENABLE <= '1';

                if (BTN_START = '1' and BTN_LAP = '0') then
                    swch_nst <= CNTR_STOP;
                elsif (BTN_START = '0' and BTN_LAP = '1') then
                    swch_nst <= LAP;
                end if;

            when LAP =>

                CNT_ENABLE <= '1';

                if (BTN_START = '1' and BTN_LAP = '0') then
                    swch_nst <= RUN;
                elsif (BTN_START = '0' and BTN_LAP = '1') then
                    swch_nst <= REFRESH;
                end if;

            when REFRESH =>

                swch_nst    <= LAP;
                CNT_ENABLE  <= '1';
                DISP_ENABLE <= '1';

            when CNTR_STOP =>

                DISP_ENABLE <= '1';

                if (BTN_START = '1' and BTN_LAP = '0') then
                    swch_nst <= RUN;
                elsif (BTN_START = '0' and BTN_LAP = '1') then
                    swch_nst <= IDLE;
                end if;
        end case;
    end process;

end architecture;
