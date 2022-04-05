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
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) := (others => '0');
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0) := (others => '0')
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

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
  SIGNAL ce_fade            : STD_LOGIC;
  SIGNAL ce_sh_reg          : STD_LOGIC;

  SIGNAL btn_deb_o          : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_posedge_o      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_negedge_o      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_edge_o         : STD_LOGIC_VECTOR( 3 DOWNTO 0);

  signal fade_cntr : std_logic_vector(7 downto 0);

  type fade_sh_reg_type is array (7 downto 0) of std_logic_vector(7 downto 0);
  signal fade_sh_reg : fade_sh_reg_type := (others => (others => '0'));

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

----------------------------------------------------------------------------------
-- PWM driver
----------------------------------------------------------------------------------

    fade_cntr_ce_i : ce_gen
    GENERIC MAP(
        DIV_FACT            => 3000000)
    PORT MAP(
        clk                 => clk,
        srst                => '0',
        ce                  => '1',
        ce_o                => ce_fade);

    fade_cntr_i : entity work.CNT_GEN
    generic map (
        MAX_VAL     => 255,
        LENGTH      => 8,
        INC_VAL     => 16
    )
    port map(
        CLK     => clk,
        RST     => '0',
        EN      => ce_fade,
        CNT_OUT => fade_cntr,
        OVF     => open
    );

    -- sh_reg_ce_i : ce_gen
    -- GENERIC MAP(
    --     DIV_FACT            => 500005)
    -- PORT MAP(
    --     clk                 => clk,
    --     srst                => '0',
    --     ce                  => '1',
    --     ce_o                => ce_sh_reg);

    fade_sh_reg_p : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (ce_fade = '1') then
                fade_sh_reg <= fade_sh_reg(6 downto 0) & fade_cntr;
            end if;
        end if;
    end process;

    pwm_driver_i : entity work.pwm_driver
    port map(
        CLK => clk,
        PWM_REF_0 => fade_sh_reg(0),
        PWM_REF_1 => fade_sh_reg(1),
        PWM_REF_2 => fade_sh_reg(2),
        PWM_REF_3 => fade_sh_reg(3),
        PWM_REF_4 => fade_sh_reg(4),
        PWM_REF_5 => fade_sh_reg(5),
        PWM_REF_6 => fade_sh_reg(6),
        PWM_REF_7 => fade_sh_reg(7),
        PWM_OUT => led_o,
        CNT_OUT => open
    );

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
