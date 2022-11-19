

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity TOP_FPGA is
  port(
    CLK        : in  std_logic;
    BTN_I      : in  std_logic_vector (3 downto 0);
    SW_I       : in  std_logic_vector (9 downto 0);
    LED_O      : out std_logic_vector (9 downto 0) := (others => '0');
    DISP_DIG_0 : out std_logic_vector (6 downto 0) := (others => '0');
    DISP_DIG_1 : out std_logic_vector (6 downto 0) := (others => '0');
    DISP_DIG_2 : out std_logic_vector (6 downto 0) := (others => '0');
    DISP_DIG_3 : out std_logic_vector (6 downto 0) := (others => '0');
    DISP_DIG_4 : out std_logic_vector (6 downto 0) := (others => '0');
    DISP_DIG_5 : out std_logic_vector (6 downto 0) := (others => '0')
    );
end entity;

architecture FULL of TOP_FPGA is

  constant PWM_RESOLUTION : positive := 8;
  constant NUM_LEDS : positive := 10;

  signal ce_fade      : std_logic;
  signal ce_sh_reg    : std_logic;

  signal fade_cntr : std_logic_vector(PWM_RESOLUTION -1 downto 0);

  type fade_sh_reg_type is array (NUM_LEDS -1 downto 0) of std_logic_vector(PWM_RESOLUTION -1 downto 0);
  signal fade_sh_reg : fade_sh_reg_type := (others => (others => '0'));

begin

  -- ===============================================================================================
  -- Clock divider
  -- ===============================================================================================
  clk_div_i : entity work.CNT_GEN
    generic map (
      MAX_VAL          => 2000000,
      LENGTH           => 32,
      INC_VAL          => 1,
      AUTO_REVERSE_DIR => FALSE,
      DYNAMIC_CNT_DIR  => FALSE)
    port map (
      CLK     => CLK,
      RST     => not BTN_I(0),

      EN      => '1',
      CNT_DIR => '0',
      CNT_OUT => open,
      OVF     => ce_fade,
      UNF     => open);

  -- ===============================================================================================
  -- PWM driver
  -- ===============================================================================================
  fade_cntr_i : entity work.CNT_GEN
    generic map (
      MAX_VAL => 255,
      LENGTH  => PWM_RESOLUTION,
      INC_VAL => 16,
      AUTO_REVERSE_DIR => TRUE,
      DYNAMIC_CNT_DIR => FALSE
      )
    port map(
      CLK     => CLK,
      RST     => not BTN_I(0),
      EN      => ce_fade,
      CNT_DIR => '0',
      CNT_OUT => fade_cntr,
      OVF     => open,
      UNF     => open
      );

  fade_sh_reg_p : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (ce_fade = '1') then
        fade_sh_reg <= fade_sh_reg(NUM_LEDS -2 downto 0) & fade_cntr;
      end if;
    end if;
  end process;

  pwm_driv_g : for i in 0 to (NUM_LEDS -1) generate
    pwm_driv_i : entity work.PWM_DRIVER
      generic map (
        RESOLUTION => PWM_RESOLUTION)
      port map (
        CLK     => CLK,
        PWM_REF => fade_sh_reg(i),
        PWM_OUT => LED_O(i),
        CNT_OUT => open);
  end generate;

end architecture;
