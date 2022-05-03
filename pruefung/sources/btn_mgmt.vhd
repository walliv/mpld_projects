-- btn_mgmt.vhd: button input circuit which debounces and detect edges of the input
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity BTN_MGMT is

    generic (
        DEB_PERIOD : positive := 5);

    port (
        CLK           : in  std_logic;
        CE            : in  std_logic;
        BTN_IN        : in  std_logic;
        BTN_DEBOUNCED : out std_logic;
        BTN_EDGE_POS  : out std_logic;
        BTN_EDGE_NEG  : out std_logic;
        BTN_EDGE_ANY  : out std_logic);

end entity;

architecture FULL of BTN_MGMT is

    signal sig_btn_debounced : std_logic;
    signal sig_sync_reg_out  : std_logic;

begin

    sync_reg_i : entity work.SYNC_REG
        port map (
            CLK     => CLK,
            SIG_IN  => BTN_IN,
            SIG_OUT => sig_sync_reg_out);

    debouncer_i : entity work.DEBOUNCER
        generic map (
            DEB_PERIOD => DEB_PERIOD)
        port map (
            CLK     => CLK,
            RST     => '0',
            CE      => CE,
            BTN_IN  => sig_sync_reg_out,
            BTN_OUT => sig_btn_debounced);

    edge_detector_i : entity work.EDGE_DETECTOR
        port map (
            CLK      => CLK,
            SIG_IN   => sig_btn_debounced,
            EDGE_POS => BTN_EDGE_POS,
            EDGE_NEG => BTN_EDGE_NEG,
            EDGE_ANY => BTN_EDGE_ANY);

    BTN_DEBOUNCED <= sig_btn_debounced;

end architecture;
