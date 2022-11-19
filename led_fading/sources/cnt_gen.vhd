-- cnt_gen.vhd: Generic implementation of a binary counter with reversable counting direction
-- Author(s): Vladislav Valek  <xvalek14@vutbr.cz>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Note:

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CNT_GEN is
    generic(
        -- Maximum value by which, the overflow of the counter occurs
        MAX_VAL          : natural  := 511;
        LENGTH           : positive := 32;
        -- Value by which the counter is incremented/decremented
        INC_VAL          : positive := 1;
        -- When True, the counting direction reverses automatically when reaches the specific limit
        -- value (MAX_VAL when counting UP and 0 when counting DOWN). When False, the counter
        -- keeps the counting direction specified by CNT_DIR input and when reaching the limit
        -- values, the counter overflows or underflows.
        AUTO_REVERSE_DIR : boolean  := FALSE;
        -- Allow dynamic change of counter direction
        DYNAMIC_CNT_DIR  : boolean  := FALSE
        );
    port(
        CLK     : in std_logic;
        RST     : in std_logic;
        EN      : in std_logic;
        -- 1 for DOWN, 0 for UP. Inactive when DYNAMIC_CNT_DIR set to false
        CNT_DIR : in std_logic;

        CNT_OUT : out std_logic_vector(LENGTH-1 downto 0);
        OVF     : out std_logic;
        UNF     : out std_logic
        );
end entity;

architecture FULL of CNT_GEN is

    -- implicit overflow value by which the counter automatically overflows because of its length
    constant OVF_VAL : unsigned(LENGTH-1 downto 0) := to_unsigned(MAX_VAL, LENGTH);
    constant NUL_VAL : unsigned(LENGTH-1 downto 0) := (others => '0');

    signal cnt_dir_pst : std_logic                   := '0';
    signal cnt_dir_nst : std_logic                   := '0';
    signal cnt_pst     : unsigned(LENGTH-1 downto 0) := (others => '0');
    signal cnt_nst     : unsigned(LENGTH-1 downto 0) := (others => '0');

begin


    aut_rev_dir_g : if (AUTO_REVERSE_DIR and (not DYNAMIC_CNT_DIR)) generate

        cnt_state_reg_p : process (CLK) is
        begin
            if (rising_edge(CLK)) then
                if (RST = '1') then
                    cnt_dir_pst <= '0';
                    cnt_pst     <= (others => '0');
                elsif (EN = '1') then
                    cnt_dir_pst <= cnt_dir_nst;
                    cnt_pst     <= cnt_nst;
                end if;
            end if;
        end process;

        cnt_nst_logic_p : process (all) is
        begin
            cnt_dir_nst <= cnt_dir_pst;
            cnt_nst     <= cnt_pst;

            if (cnt_dir_pst = '0') then

                if (cnt_pst >= (OVF_VAL - INC_VAL + 1)) then
                    cnt_dir_nst <= '1';
                    cnt_nst     <= cnt_pst - INC_VAL;
                else
                    cnt_nst <= cnt_pst + INC_VAL;
                end if;

            elsif (cnt_dir_pst = '1') then

                if (cnt_pst <= (NUL_VAL + INC_VAL - 1)) then
                    cnt_dir_nst <= '0';
                    cnt_nst     <= cnt_pst + INC_VAL;
                else
                    cnt_nst <= cnt_pst - INC_VAL;
                end if;
            end if;
        end process;

    elsif ((not AUTO_REVERSE_DIR) and DYNAMIC_CNT_DIR) generate

        cnt_state_reg_p : process (CLK) is
        begin
            if (rising_edge(CLK)) then
                if (RST = '1') then
                    cnt_pst <= (others => '0');
                elsif (EN = '1') then
                    cnt_pst <= cnt_nst;
                end if;
            end if;
        end process;

        cnt_nst_logic_p : process (all) is
        begin
            cnt_nst <= cnt_pst;

            if (CNT_DIR = '1') then
                cnt_nst <= cnt_pst - INC_VAL;

                if (cnt_pst = 0) then
                    cnt_nst <= OVF_VAL;
                end if;
            else
                cnt_nst <= cnt_pst + INC_VAL;

                if (cnt_pst >= OVF_VAL) then
                    cnt_nst <= (others => '0');
                end if;
            end if;
        end process;

    else generate

        cnt_state_reg_p : process (CLK) is
        begin
            if (rising_edge(CLK)) then
                if (RST = '1') then
                    cnt_pst <= (others => '0');
                elsif (EN = '1') then
                    cnt_pst <= cnt_nst;
                end if;
            end if;
        end process;

        cnt_nst_logic_p : process (all) is
        begin
            if (cnt_pst >= (OVF_VAL - INC_VAL + 1)) then
                cnt_nst <= (others => '0');
            else
                cnt_nst <= cnt_pst + INC_VAL;
            end if;
        end process;

    end generate;

    OVF     <= '1' when (cnt_pst = OVF_VAL) else '0';
    UNF     <= '1' when (cnt_pst = NUL_VAL) else '0';
    CNT_OUT <= std_logic_vector(cnt_pst);

end architecture;
