library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity STOPWATCH is
  port (
    CLK         : in std_logic;
    RST         : in std_logic := '0';
    CE_100HZ    : in std_logic;

    CNT_ENABLE  : in std_logic;
    DISP_ENABLE : in std_logic;
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

    signal cnt_0_int : std_logic_vector(CNT_0'range);
    signal cnt_1_int : std_logic_vector(CNT_1'range);
    signal cnt_2_int : std_logic_vector(CNT_2'range);
    signal cnt_3_int : std_logic_vector(CNT_3'range);

begin

    sec_decimals_i : entity work.CNT_GEN
        generic map(
            MAX_VAL => 4,
            LENGTH  => 4
        )
        port map(
            CLK     => CLK,
            RST     => RST or CNT_RESET,
            EN      => sec_units_ovf,
            CNT_OUT => cnt_3_int,
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
            EN      => msec_decimals_ovf,
            CNT_OUT => cnt_2_int,
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
            EN      => msec_units_ovf,
            CNT_OUT => cnt_1_int,
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
            CNT_OUT => cnt_0_int,
            OVF     => msec_units_ovf
        );

    
    output_enable_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (RST = '1' or CNT_RESET = '1') then

                CNT_0 <= (others => '0');
                CNT_1 <= (others => '0');
                CNT_2 <= (others => '0');
                CNT_3 <= (others => '0');

            elsif (DISP_ENABLE = '1') then

                CNT_0 <= cnt_0_int;
                CNT_1 <= cnt_1_int;
                CNT_2 <= cnt_2_int;
                CNT_3 <= cnt_3_int;
                
            end if;        
        end if;
    end process;


end architecture;