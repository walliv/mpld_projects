-- segment_cycle.vhd:
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>
--
-- SPDX-License-Identifier: BSD-3-Clause

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEGMENT_CYCLE is

    generic (
        DIV_FACTOR : positive := 15000000);

    port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;
        SEG_DIG : out std_logic_vector(6 downto 0));
end entity;

architecture FULL of SEGMENT_CYCLE is

    signal clk_en      : std_logic;
    signal seg_dig_six : std_logic_vector(5 downto 0);

begin

    clk_div_i : entity work.CNT_GEN
        generic map (
            MAX_VAL          => DIV_FACTOR,
            LENGTH           => 32,
            INC_VAL          => 1,
            AUTO_REVERSE_DIR => FALSE,
            DYNAMIC_CNT_DIR  => FALSE)
        port map (
            CLK     => CLK,
            RST     => RESET,
            EN      => '1',
            CNT_DIR => '0',
            CNT_OUT => open,
            OVF     => clk_en,
            UNF     => open);

    seg_roate_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RESET = '1') then
                seg_dig_six <= "000011";
            elsif (clk_en = '1') then
                seg_dig_six <= seg_dig_six(4 downto 0) & seg_dig_six(5);
            end if;
        end if;
    end process;

    SEG_DIG <= '1' & seg_dig_six;

end architecture;
