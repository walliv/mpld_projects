----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
----------------------------------------------------------------------------------
entity rp_top is
    port(
        clk        : in  std_logic;
        btn_i      : in  std_logic_vector (3 downto 0);
        sw_i       : in  std_logic_vector (3 downto 0);
        led_o      : out std_logic_vector (7 downto 0);
        disp_seg_o : out std_logic_vector (7 downto 0);
        disp_dig_o : out std_logic_vector (4 downto 0)
        );
end rp_top;
----------------------------------------------------------------------------------
architecture Structural of rp_top is
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
    end component seg_disp_driver;

    ------------------------------------------------------------------------------

    signal cnt_0 : std_logic_vector(3 downto 0);
    signal cnt_1 : std_logic_vector(3 downto 0);
    signal cnt_2 : std_logic_vector(3 downto 0);
    signal cnt_3 : std_logic_vector(3 downto 0);

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
            clk        => clk,
            dig_1_i    => cnt_3,
            dig_2_i    => cnt_2,
            dig_3_i    => cnt_1,
            dig_4_i    => cnt_0,
            dp_i       => "0000",
            dots_i     => "011",
            disp_seg_o => disp_seg_o,
            disp_dig_o => disp_dig_o
            );

    --------------------------------------------------------------------------------
    -- clock enable generator



    --------------------------------------------------------------------------------
    -- button input module



    --------------------------------------------------------------------------------
    -- stopwatch module (4-decade BCD counter)



    --------------------------------------------------------------------------------
    -- stopwatch control FSM



----------------------------------------------------------------------------------
end Structural;
----------------------------------------------------------------------------------
