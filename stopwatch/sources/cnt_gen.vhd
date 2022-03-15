
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CNT_GEN is
    generic(
        MAX_VAL : natural  := 0;
        LENGTH  : positive := 32
        );
    port(
        CLK : in std_logic;
        RST : in std_logic;
        EN  : in std_logic;

        CNT_OUT : out std_logic_vector(LENGTH-1 downto 0);
        OVF     : out std_logic
        );
end entity;

architecture FULL of CNT_GEN is

    -- implicit overflow value by which the counter automatically overflows because of its length
    constant OVF_VAL : unsigned(LENGTH-1 downto 0) := (others => '1');

    signal cnt_int : unsigned(LENGTH-1 downto 0) := (others => '0');

begin

    mx_val_g : if ((MAX_VAL = 0) or (MAX_VAL >= (2**LENGTH -1))) generate

        cnt_p : process (CLK) is
        begin
            if (rising_edge(CLK)) then

                if (RST = '1') then
                    cnt_int <= (others => '0');
                elsif (EN = '1') then
                    cnt_int <= cnt_int + 1;
                end if;
            end if;
        end process;

    else generate

        cnt_p : process (CLK) is
        begin
            if (rising_edge(CLK)) then

                if (RST = '1') then
                    cnt_int <= (others => '0');
                elsif (EN = '1') then

                    -- resets counter when MAX_VAL has been reached
                    if (cnt_int = MAX_VAL) then
                        cnt_int <= (others => '0');
                    else
                        cnt_int <= cnt_int + 1;
                    end if;

                end if;
            end if;
        end process;
    end generate;

    OVF <= '1' when (cnt_int = MAX_VAL) else '0';
    CNT_OUT <= std_logic_vector(cnt_int);

end architecture;
