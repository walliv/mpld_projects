-- segm_ctrl.vhd:
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>
--
-- SPDX-License-Identifier: BSD-3-Clause

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEGM_CTRL is
    port (
        CLK          : in  std_logic;
        RESET        : in  std_logic;
        SEGM_ALL_OUT : out std_logic_vector(6*7 -1 downto 0));
end entity;

architecture FULL of SEGM_CTRL is

    signal segm_cycl : std_logic_vector(SEGM_ALL_OUT'range);
    signal segm_cntr : unsigned(2 downto 0);

    type segm_printing_state is (S_CYCLING, S_REVEAL_ONE_LETTER, S_SLIDE_AWAY);
    signal segm_print_pst : segm_printing_state := S_CYCLING;
    signal segm_print_nst : segm_printing_state := S_CYCLING;

    signal print_segm : std_logic_vector(SEGM_ALL_OUT'range);
    signal print_cycle_mux : std_logic_vector(SEGM_ALL_OUT'range);
    signal mux_sel : std_logic_vector(5 downto 0);

    type char_select_type is array (5 downto 0) of std_logic_vector(3 downto 0);
    signal char_select : char_select_type := (others => (others => '1'));

begin

    SEGM_ALL_OUT <= print_cycle_mux;

    segm_cycle_g : for i in 0 to 5 generate
        segment_cycle_i : entity work.SEGMENT_CYCLE
            generic map (
                DIV_FACTOR => 3000000)
            port map (
                CLK     => CLK,
                RESET   => RESET,
                SEG_DIG => segm_cycl(i*7 + 6 downto i*7));

        print_cycle_mux(i*7 + 6 downto i*7) <= segm_cycl(i*7+6 downto i*7) when mux_sel(i) = '1' else print_segm(i*7+6 downto i*7);

        char_printer_i: entity work.CHAR_PRINTER
            port map (
                CLK      => CLK,
                RESET    => RESET,
                CHAR_SEL => char_select(i),
                SEG_DIG  => print_segm(i*7+6 downto i*7));
    end generate;

    clk_div_i : entity work.CNT_GEN
        generic map (
            MAX_VAL          => 35000000,
            LENGTH           => 32,
            INC_VAL          => 1,
            AUTO_REVERSE_DIR => false,
            DYNAMIC_CNT_DIR  => false)
        port map (
            CLK     => CLK,
            RST     => RESET,
            EN      => '1',
            CNT_DIR => '0',
            CNT_OUT => open,
            OVF     => clk_en,
            UNF     => open);

    segm_print_state_reg_p: process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                segm_print_pst <= S_CYCLING;
            elsif (clk_en = '1') then
                segm_print_pst <= segm_print_nst;
            end if;
        end if;
    end process;

    segm_print_nst_logic_p : process (all) is
    begin
        segm_print_nst <= segm_print_nst;

        case segm_print_pst is
            when S_CYCLING =>


            when others => null;
        end case;
    end process;
end architecture;
