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

signal pwm_ref_0 : std_logic_vector(7 downto 0);
signal pwm_ref_1 : std_logic_vector(7 downto 0);
signal pwm_ref_2 : std_logic_vector(7 downto 0);
signal pwm_ref_3 : std_logic_vector(7 downto 0);
signal pwm_ref_4 : std_logic_vector(7 downto 0);
signal pwm_ref_5 : std_logic_vector(7 downto 0);
signal pwm_ref_6 : std_logic_vector(7 downto 0);
signal pwm_ref_7 : std_logic_vector(7 downto 0);
signal pwm_cntr : std_logic_vector(7 downto 0);
signal pwm_out : std_logic_vector(7 downto 0);

signal seg_dig_1 : std_logic_vector(3 downto 0);
signal seg_dig_2 : std_logic_vector(3 downto 0);
signal seg_dig_3 : std_logic_vector(3 downto 0);
signal seg_dig_4 : std_logic_vector(3 downto 0);
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
    dig_1_i             => seg_dig_1,
    dig_2_i             => seg_dig_2,
    dig_3_i             => seg_dig_3,
    dig_4_i             => seg_dig_4,
    dp_i                => "0000",
    dots_i              => "011",
    disp_seg_o          => disp_seg_o,
    disp_dig_o          => disp_dig_o);
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- PWM driver
----------------------------------------------------------------------------------

    pwm_driver_i : entity work.pwm_driver
    port map(
        CLK => clk,
        PWM_REF_0 => pwm_ref_0,
        PWM_REF_1 => pwm_ref_1,
        PWM_REF_2 => pwm_ref_2,
        PWM_REF_3 => pwm_ref_3,
        PWM_REF_4 => pwm_ref_4,
        PWM_REF_5 => pwm_ref_5,
        PWM_REF_6 => pwm_ref_6,
        PWM_REF_7 => pwm_ref_7,
        PWM_OUT => pwm_out,
        CNT_OUT => pwm_cntr
    );

    led_o <= pwm_out;
    
    pwm_vio_i : entity work.pwm_vio_1
    port map (
        clk => clk,
        probe_in0 => pwm_out,
        probe_in1 => pwm_cntr,
        probe_out0 => pwm_ref_0,
        probe_out1 => pwm_ref_1,
        probe_out2 => pwm_ref_2,
        probe_out3 => pwm_ref_3,
        probe_out4 => pwm_ref_4,
        probe_out5 => pwm_ref_5,
        probe_out6 => pwm_ref_6,
        probe_out7 => pwm_ref_7,
        probe_out8 => seg_dig_1,
        probe_out9 => seg_dig_2,
        probe_out10 => seg_dig_3,
        probe_out11 => seg_dig_4
    );

    pwm_ila_i : entity work.pwm_ila_1
    port map(
        clk => clk,
        probe0 => pwm_out,
        probe1 => pwm_cntr,
        probe2 => btn_i,
        probe3 => sw_i
    );
----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
