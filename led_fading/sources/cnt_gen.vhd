
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CNT_GEN is
    generic(
        MAX_VAL : natural  := 0;
        LENGTH  : positive := 32;
        INC_VAL : positive := 1
        );
    port(
        CLK : in std_logic;
        RST : in std_logic;
        EN  : in std_logic;

        CNT_OUT : out std_logic_vector(LENGTH-1 downto 0);
        OVF     : out std_logic;
        UVF     : out std_logic
        );
end entity;

architecture FULL of CNT_GEN is

    -- implicit overflow value by which the counter automatically overflows because of its length
    constant OVF_VAL : unsigned(LENGTH-1 downto 0) := (others => '1');
    constant NUL_VAL : unsigned(LENGTH-1 downto 0) := (others => '0');

    signal cnt_dir : std_logic := '1';
    signal cnt_int : unsigned(LENGTH-1 downto 0) := (others => '0');

begin

    cnt_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then

            if (RST = '1') then
                cnt_int <= (others => '0');
            elsif (EN = '1') then

                if (cnt_dir = '1') then

                    if (cnt_int >= (MAX_VAL - INC_VAL)) then
                        cnt_dir <= '0';
                    else
                        cnt_int <= cnt_int + INC_VAL;
                    end if;

                elsif (cnt_dir = '0') then

                    if (cnt_int <= (NUL_VAL + INC_VAL)) then
                        cnt_dir <= '1';
                    else
                        cnt_int <= cnt_int - INC_VAL;
                    end if;
                    
                end if ;

            end if;
        end if;
    end process;

    OVF     <= '1' when (cnt_int = MAX_VAL) else '0';
    UVF     <= '1' when (cnt_int = NUL_VAL) else '0';
    CNT_OUT <= std_logic_vector(cnt_int);

end architecture;
