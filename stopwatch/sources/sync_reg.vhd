-- sync_reg.vhd: removes metastability on the intput, this is a.k.a. ASYNC_OPEN_LOOP component
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SYNC_REG is

    port (
        CLK     : in  std_logic;
        SIG_IN  : in  std_logic;
        SIG_OUT : out std_logic);

end entity;

architecture FULL of SYNC_REG is

    signal sig_reg     : std_logic := '0';
    signal sig_in_int  : std_logic := '0';
    signal sig_out_int : std_logic := '0';

    attribute ASYNC_REG                : string;
    attribute ASYNC_REG of sig_reg     : signal is "TRUE";
    attribute ASYNC_REG of sig_out_int : signal is "TRUE";

    attribute SHREG_EXTRACT                : string;
    attribute SHREG_EXTRACT of sig_reg     : signal is "TRUE";
    attribute SHREG_EXTRACT of sig_out_int : signal is "TRUE";

begin

    fst_reg_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            sig_reg     <= sig_in_int;
            sig_out_int <= sig_reg;
        end if;
    end process;

    sig_in_int <= SIG_IN;
    SIG_OUT    <= sig_out_int;

end architecture;
