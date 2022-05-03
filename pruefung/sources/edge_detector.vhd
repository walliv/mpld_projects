-- edge_detector.vhd: detect the rising and falling edges of the input signal
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EDGE_DETECTOR is

    port (
        CLK      : in  std_logic;
        SIG_IN   : in  std_logic;
        EDGE_POS : out std_logic;
        EDGE_NEG : out std_logic;
        EDGE_ANY : out std_logic);

end entity;

architecture FULL of EDGE_DETECTOR is

    signal sig_in_delay : std_logic;
    signal edge_pos_int : std_logic;
    signal edge_neg_int : std_logic;

begin

    sig_in_delay_p: process (CLK) is
    begin
        if (rising_edge(CLK)) then
            sig_in_delay <= SIG_IN;
        end if;
    end process;

    -- somehow adjusted XOR functions
    edge_pos_int <= '1' when (sig_in_delay = '0' and SIG_IN = '1') else '0';
    edge_neg_int <= '1' when (sig_in_delay = '1' and SIG_IN = '0') else '0';

    EDGE_POS <= edge_pos_int;
    EDGE_NEG <= edge_neg_int;
    EDGE_ANY <= edge_pos_int or edge_neg_int;



end architecture;
