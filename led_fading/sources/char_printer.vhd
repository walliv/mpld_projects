-- char_printer.vhd:
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>
--
-- SPDX-License-Identifier: BSD-3-Clause

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CHAR_PRINTER is
    port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;
        CHAR_SEL : in std_logic_vector(3 downto 0);
        SEG_DIG : out std_logic_vector(6 downto 0));
end entity;

architecture FULL of CHAR_PRINTER is

    type char_mem_t is array (0 to 15) of std_logic_vector(6 downto 0);
    constant char_mem : char_mem_t :=
        (
            "0001000",                  -- A
            "0000000",                  -- B
            "0000110",                  -- C
            "0000110",                  -- E
            "0001110",                  -- F
            "0001001",                  -- H
            "1001111",                  -- I
            "1000011",                  -- L
            "1000000",                  -- O
            "0001100",                  -- P
            "0010010",                  -- S
            "1100000",                  -- U
            "0001101",                  -- Y
            others => (others => '1'));
begin

    char_sel_p: process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RESET = '1') then
                SEG_DIG <= (others => '1');
            else
                SEG_DIG <= char_mem(to_integer(unsigned(CHAR_SEL)));
            end if;
        end if;
    end process;
end architecture;
