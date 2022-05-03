-- debouncer.vhd: button debouncing circuit
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DEBOUNCER is

    generic (
        -- maximum is 15 :))))
        DEB_PERIOD : positive := 5);

    port (
        CLK     : in  std_logic;
        RST     : in  std_logic;
        CE      : in  std_logic;
        BTN_IN  : in  std_logic;
        BTN_OUT : out std_logic);

end entity;

architecture FULL of DEBOUNCER is

    signal pen_cntr_ovf : std_logic := '0';

begin

    -- this counter serves as a wait timer (recommended maximum value is 20--50 ms, period of the CE signal is
    -- 10ms)
    pending_cntr_i : entity work.CNT_GEN
        generic map (
            LENGTH  => 4)
        port map (
            CLK     => CLK,
            RST     => RST,
            EN      => CE,
            MAX_VAL => std_logic_vector(to_unsigned(DEB_PERIOD,4)),

            CNT_OUT => open,
            OVF     => pen_cntr_ovf);

    -- this register samples the value of the output each time the pending_cntr_i overflows
    sample_input_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then

                BTN_OUT <= '0';

            elsif (pen_cntr_ovf = '1') then

                BTN_OUT <= BTN_IN;

            end if;
        end if;
    end process;

end architecture;
