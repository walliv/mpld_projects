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

    signal ce_100hz     : std_logic;

    signal btn_pressed  : std_logic_vector(3 downto 0);
    signal keycode_leds : std_logic_vector(3 downto 0);

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
            dig_1_i    => (others => '0'),
            dig_2_i    => (others => '0'),
            dig_3_i    => (others => '0'),
            dig_4_i    => (others => '0'),
            dp_i       => "0000",
            dots_i     => "011",
            disp_seg_o => DISP_SEG_O,
            disp_dig_o => DISP_DIG_O
            );

    --------------------------------------------------------------------------------
    -- clock enable generator

    ce_gen_i : entity work.CE_GEN
        generic map (
            DIV_FACT => 10)
        port map (
            CLK    => CLK,
            SRST   => '0',
            CE_IN  => '1',
            CE_OUT => ce_100hz);

    --------------------------------------------------------------------------------
    -- button input module

    btn_mgmt_g : for i in 0 to 3 generate
        
        btn_mgmt_i : entity work.BTN_MGMT
            generic map (
                DEB_PERIOD => 2)
            port map (
                CLK           => CLK,
                CE            => ce_100hz,
                BTN_IN        => BTN_I(i),
                BTN_DEBOUNCED => open,
                BTN_EDGE_POS  => open,
                BTN_EDGE_NEG  => btn_pressed(i),
                BTN_EDGE_ANY  => open);

    end generate;

    --------------------------------------------------------------------------------
    -- keycode control FSM

    code_key_fsm_i : entity work.CODE_KEY_FSM
        port map (
            CLK     => CLK,
            RST     => SW_I(0),
            CLK_EN  => ce_100hz,
            BTN     => btn_pressed,
            LED_INF => keycode_leds);

    LED_O <= (
        7 => keycode_leds(3),
        5 => keycode_leds(2),
        3 => keycode_leds(1),
        1 => keycode_leds(0),
        others => '0'        
    );
----------------------------------------------------------------------------------
end architecture;
----------------------------------------------------------------------------------
