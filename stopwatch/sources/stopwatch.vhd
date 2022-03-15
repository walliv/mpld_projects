library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity STOPWATCH is
  port (
    CLK         : in std_logic;
    RST         : in std_logic := '0';
    CE_100HZ    : in std_logic;

    CNT_ENABLE  : in std_logic;
    CNT_RESET   : in std_logic;

    CNT_0 : out std_logic_vector(3 downto 0);
    CNT_1 : out std_logic_vector(3 downto 0);
    CNT_2 : out std_logic_vector(3 downto 0);
    CNT_3 : out std_logic_vector(3 downto 0)
  ) ;
end entity;

architecture FULL of STOPWATCH is

    signal sec_units_ovf : std_logic;
    signal msec_decimals_ovf : std_logic;
    signal msec_units_ovf : std_logic;

begin

    sec_decimals_i : entity work.CNT_GEN
        generic map(
            MAX_VAL => 4,
            LENGTH  => 4
        )
        port map(
            CLK     => CLK,
            RST     => RST or CNT_RESET,
            CNT_OUT => CNT_3,
            OVF     => open
        );

    sec_units_i : entity work.CNT_GEN
        generic map(
            MAX_VAL => 9,
            LENGTH  => 4
        )
        port map(
            CLK     => CLK,
            RST     => RST or CNT_RESET,
            CNT_OUT => CNT_2,
            OVF     => sec_units_ovf
        );

    msec_decimals_i : entity work.CNT_GEN
        generic map(
            MAX_VAL => 9,
            LENGTH => 4
        )
        port map(
            CLK     => CLK,
            RST     => RST or CNT_RESET,
            CNT_OUT => CNT_1,
            OVF     => msec_decimals_ovf
        );

    msec_units_i : entity work.CNT_GEN
        generic map(
            MAX_VAL => 9,
            LENGTH => 4
        )
        port map(
            CLK     => CLK,
            RST     => RST or CNT_RESET,
            EN      => CE_100HZ and CNT_ENABLE,
            CNT_OUT => CNT_0,
            OVF     => msec_units_ovf
        );

end architecture;