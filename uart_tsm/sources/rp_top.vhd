----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    clk             : IN  STD_LOGIC;
    btn_i           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    sw_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    led_o           : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
    clk                 : IN  STD_LOGIC;
    dig_1_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_2_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_3_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_4_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dp_i                : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    dots_i              : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    disp_seg_o          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o          : OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
  END COMPONENT;

  ------------------------------------------------------------------------------

  COMPONENT btn_in
  GENERIC(
    DEB_PERIOD          : INTEGER := 10);
  PORT(
    clk                 : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    btn_i               : IN  STD_LOGIC;
    btn_deb_o           : OUT STD_LOGIC;
    btn_posedge_o       : OUT STD_LOGIC;
    btn_negedge_o       : OUT STD_LOGIC;
    btn_edge_o          : OUT STD_LOGIC);
  END COMPONENT;

  --------------------------------------------------------------------------------

  COMPONENT ce_gen
  GENERIC(
    DIV_FACT            : POSITIVE := 2);
  PORT (
    clk                 : IN  STD_LOGIC;
    srst                : IN  STD_LOGIC;
    ce                  : IN  STD_LOGIC;
    ce_o                : OUT STD_LOGIC);
  END COMPONENT;

  --------------------------------------------------------------------------------

  SIGNAL clk_en_100Hz       : STD_LOGIC;

  SIGNAL btn_deb_o          : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_posedge_o      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_negedge_o      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_edge_o         : STD_LOGIC_VECTOR( 3 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  ce_gen_i : ce_gen
  GENERIC MAP(
    DIV_FACT            => 500000)
  PORT MAP(
    clk                 => clk,
    srst                => '0',
    ce                  => '1',
    ce_o                => clk_en_100Hz);

  --------------------------------------------------------------------------------

  GEN_btn_in: FOR i IN 0 TO 3 GENERATE
    btn_in_i : btn_in
    GENERIC MAP(
      DEB_PERIOD          => 5)
    PORT MAP(
      clk                 => clk,
      ce                  => clk_en_100Hz,
      btn_i               => btn_i(i),
      btn_deb_o           => btn_deb_o(i),
      btn_posedge_o       => btn_posedge_o(i),
      btn_negedge_o       => btn_negedge_o(i),
      btn_edge_o          => btn_edge_o(i));
  END GENERATE GEN_btn_in;

  --------------------------------------------------------------------------------

  led_o(7 DOWNTO 0) <= (OTHERS => '0');

  --------------------------------------------------------------------------------
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
  PORT MAP(
    clk                 => clk,
    dig_1_i             => "0000",
    dig_2_i             => "0000",
    dig_3_i             => "0000",
    dig_4_i             => "0000",
    dp_i                => "0000",
    dots_i              => "011",
    disp_seg_o          => disp_seg_o,
    disp_dig_o          => disp_dig_o);

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
