-- ce_gen.vhd: simple clock divider with adjustable division factor
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CE_GEN is
    generic(
        DIV_FACT : positive := 50
        );
    port(
        CLK    : in  std_logic;
        SRST   : in  std_logic;
        CE_IN  : in  std_logic;
        CE_OUT : out std_logic
        );
end entity;

architecture FULL of CE_GEN is

    constant CNT_LENGTH : positive := 32;
begin

    cnt_gen_i : entity work.CNT_GEN
        generic map(
            LENGTH  => CNT_LENGTH
            )
        port map(
            CLK     => CLK,
            RST     => SRST,
            EN      => CE_IN,
            MAX_VAL => std_logic_vector(to_unsigned(DIV_FACT - 1,CNT_LENGTH)),

            CNT_OUT => open,
            OVF     => CE_OUT
            );

end architecture;
