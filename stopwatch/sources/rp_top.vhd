----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------------------------------------
entity RP_TOP is
    port(
        CLK        : in  std_logic;
        BTN_I      : in  std_logic_vector (3 downto 0);
        SW_I       : in  std_logic_vector (3 downto 0);
        LED_O      : out std_logic_vector (7 downto 0);
        DISP_SEG_O : out std_logic_vector (7 downto 0);
        DISP_DIG_O : out std_logic_vector (4 downto 0)
        );
end entity;
----------------------------------------------------------------------------------
architecture STRUCTURAL of RP_TOP is
----------------------------------------------------------------------------------

    component seg_disp_driver
        port(
            clk        : in  std_logic;
            dig_1_i    : in  std_logic_vector (3 downto 0);
            dig_2_i    : in  std_logic_vector (3 downto 0);
            dig_3_i    : in  std_logic_vector (3 downto 0);
            dig_4_i    : in  std_logic_vector (3 downto 0);
            dp_i       : in  std_logic_vector (3 downto 0);  -- [DP4 DP3 DP2 DP1]
            dots_i     : in  std_logic_vector (2 downto 0);  -- [L3 L2 L1]
            disp_seg_o : out std_logic_vector (7 downto 0);
            disp_dig_o : out std_logic_vector (4 downto 0)
            );
    end component;

    ------------------------------------------------------------------------------

    signal cnt_0_seg : std_logic_vector(3 downto 0);
    signal cnt_1_seg : std_logic_vector(3 downto 0);
    signal cnt_2_seg : std_logic_vector(3 downto 0);
    signal cnt_3_seg : std_logic_vector(3 downto 0);

    signal cnt_0 : std_logic_vector(3 downto 0);
    signal cnt_1 : std_logic_vector(3 downto 0);
    signal cnt_2 : std_logic_vector(3 downto 0);
    signal cnt_3 : std_logic_vector(3 downto 0);

    signal ce_100hz     : std_logic;
    signal cnt_reset    : std_logic;
    signal cnt_enable   : std_logic;
    signal disp_enable  : std_logic;

    signal btn_lap      : std_logic;
    signal btn_start    : std_logic;

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- display driver
    --
    --       DIG 1       DIG 2       DIG 3       DIG 4
    --                                       L3
    --       -----       -----       -----   o   -----
    --      |     |     |     |  L1 |     |     |     |
    --      |     |     |     |  o  |     |     |     |
    --       -----       -----       -----       -----
    --      |     |     |     |  o  |     |     |     |
    --      |     |     |     |  L2 |     |     |     |
    --       -----  o    -----  o    -----  o    -----  o
    --             DP1         DP2         DP3         DP4
    --
    --------------------------------------------------------------------------------

    seg_disp_driver_i : seg_disp_driver
        port map(
            clk        => CLK,
            dig_1_i    => cnt_3_seg,
            dig_2_i    => cnt_2_seg,
            dig_3_i    => cnt_1_seg,
            dig_4_i    => cnt_0_seg,
            dp_i       => "0000",
            dots_i     => "011",
            disp_seg_o => DISP_SEG_O,
            disp_dig_o => DISP_DIG_O
            );

    display_enable_p : process (CLK) is
    begin
        if (rising_edge(CLK)) then
            if (cnt_reset = '1') then

                cnt_0_seg <= (others => '0');
                cnt_1_seg <= (others => '0');
                cnt_2_seg <= (others => '0');
                cnt_3_seg <= (others => '0');

            elsif (disp_enable = '1') then

                cnt_0_seg <= cnt_0;
                cnt_1_seg <= cnt_1;
                cnt_2_seg <= cnt_2;
                cnt_3_seg <= cnt_3;
                
            end if;        
        end if;
    end process;

    LED_O <= cnt_3 & cnt_2;

    --------------------------------------------------------------------------------
    -- clock enable generator

    ce_gen_i : entity work.CE_GEN
        generic map (
            DIV_FACT => 500000)
        port map (
            CLK    => CLK,
            SRST   => SW_I(0),
            CE_IN  => '1',
            CE_OUT => ce_100hz);

    --------------------------------------------------------------------------------
    -- button input module


    btn_start_mgmt_i : entity work.BTN_MGMT
        generic map (
            DEB_PERIOD => 5)
        port map (
            CLK           => CLK,
            CE            => ce_100hz,
            BTN_IN        => BTN_I(3),
            BTN_DEBOUNCED => open,
            BTN_EDGE_POS  => btn_start,
            BTN_EDGE_NEG  => open,
            BTN_EDGE_ANY  => open);

    btn_lap_mgmt_i : entity work.BTN_MGMT
        generic map (
            DEB_PERIOD => 5)
        port map (
            CLK           => CLK,
            CE            => ce_100hz,
            BTN_IN        => BTN_I(0),
            BTN_DEBOUNCED => open,
            BTN_EDGE_POS  => btn_lap,
            BTN_EDGE_NEG  => open,
            BTN_EDGE_ANY  => open);

    --------------------------------------------------------------------------------
    -- stopwatch module (4-decade BCD counter)

    stopwatch_i : entity work.STOPWATCH
        port map (
            CLK         => CLK,
            RST         => SW_I(0),
            CE_100HZ    => ce_100hz,
            CNT_ENABLE  => cnt_enable,
            CNT_RESET   => cnt_reset,
            CNT_0       => cnt_0,
            CNT_1       => cnt_1,
            CNT_2       => cnt_2,
            CNT_3       => cnt_3);

    --------------------------------------------------------------------------------
    -- stopwatch control FSM

    stopwatch_fsm_i : entity work.STOPWATCH_FSM
        port map (
            CLK         => CLK,
            RST         => SW_I(0),
            BTN_START   => btn_start,
            BTN_LAP     => btn_lap,
            CNT_RESET   => cnt_reset,
            CNT_ENABLE  => cnt_enable,
            DISP_ENABLE => disp_enable);

----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
