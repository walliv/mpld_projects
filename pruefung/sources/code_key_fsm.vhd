-- stopwatch_fsm.vhd: this component establishes the FSM which is used for the overall controll of the design
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CODE_KEY_FSM is

    port (
        CLK     : in  std_logic;
        RST     : in  std_logic;
        BTN     : in  std_logic_vector(3 downto 0);
        CLK_EN  : in std_logic;

        LED_INF : out std_logic_vector(3 downto 0));

end entity;

architecture FULL of CODE_KEY_FSM is

    constant BTN_PRESS_DELAY    : std_logic_vector(7 downto 0) := "01100100";
    constant BTN_TIMEOUT_DELAY  : std_logic_vector(7 downto 0) := "11001000";

    type keycode_state_type is (
        S_IDLE, 
        S_0, 
        S_1, 
        S_2, 
        S_3,
        S_4, 
        S_5, 
        S_6, 
        S_CNT_TIMEOUT,
        S_CODE_PASSED,
        S_CODE_FAILED
        );

    signal keycode_pst : keycode_state_type := S_IDLE;
    signal keycode_nst : keycode_state_type := S_IDLE;

    signal rst_int          : std_logic;
    signal cnt_delay_time   : std_logic_vector(7 downto 0);
    signal cnt_timeout      : std_logic;

begin

    delay_cntr_i : entity work.CNT_GEN
    generic map(
        LENGTH => 8
    )
    port map(
        CLK => CLK,
        RST => RST or rst_int,
        EN => CLK_EN,

        -- 100 for 1s delay
        -- 200 for 2s delay
        MAX_VAL => cnt_delay_time,
        CNT_OUT => open,
        OVF => cnt_timeout

    );

    pst_reg_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                keycode_pst <= S_IDLE;
            else
                keycode_pst <= keycode_nst;
            end if;
        end if;
    end process;

    nst_logic_p : process (all) is
    begin

        keycode_nst     <= keycode_pst;
        rst_int         <= '0';
        cnt_delay_time  <= BTN_PRESS_DELAY;
        LED_INF         <= (others => '0');

        case keycode_pst is
            when S_IDLE =>

                if (BTN(0) = '1') then
                    keycode_nst <= S_0;
                    rst_int     <= '1';
                end if;

            when S_0 =>

                if (BTN(3) = '1') then

                    keycode_nst <= S_1;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(1) = '1' or
                    BTN(2) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;

            when S_1 =>

                if (BTN(2) = '1') then

                    keycode_nst <= S_2;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(1) = '1' or
                    BTN(3) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;

            when S_2 =>

                if (BTN(1) = '1') then
                    
                    keycode_nst <= S_3;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(2) = '1' or
                    BTN(3) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;

            when S_3 =>

                if (BTN(2) = '1') then

                    keycode_nst <= S_4;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(1) = '1' or
                    BTN(3) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;

            when S_4 =>

                if (BTN(3) = '1') then

                    keycode_nst <= S_5;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(1) = '1' or
                    BTN(2) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;

            when S_5 =>

                if (BTN(2) = '1') then

                    keycode_nst <= S_6;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(1) = '1' or
                    BTN(3) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;

            when S_6 =>

                if (BTN(1) = '1') then

                    keycode_nst <= S_CODE_PASSED;
                    rst_int     <= '1';

                elsif (
                    BTN(0) = '1' or
                    BTN(2) = '1' or
                    BTN(3) = '1'
                ) then

                    keycode_nst <= S_CODE_FAILED;
                    rst_int     <= '1';

                end if;

                if (cnt_timeout = '1') then
                    keycode_nst <= S_CNT_TIMEOUT;
                    rst_int     <= '1';
                end if;
            
            when S_CODE_PASSED => 
                
                LED_INF <= (others => '1');

                if (BTN(0) = '1' or BTN(1) = '1' or BTN(2) = '1' or BTN(3) = '1') then
                    keycode_nst <= S_IDLE;
                end if;

            when S_CODE_FAILED =>

                cnt_delay_time  <= BTN_TIMEOUT_DELAY;
                LED_INF         <= "0110";

                if (cnt_timeout = '1') then
                    keycode_nst <= S_IDLE;
                end if;

            when S_CNT_TIMEOUT =>

                cnt_delay_time  <= BTN_TIMEOUT_DELAY;
                LED_INF(0)      <= '1';

                if (cnt_timeout = '1') then
                    keycode_nst <= S_IDLE;
                end if;

        end case;
    end process;

end architecture;
