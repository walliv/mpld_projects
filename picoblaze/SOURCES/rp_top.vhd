----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    CLK                 : IN  STD_LOGIC;
    BTN                 : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW                  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED                 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG            : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    UART_RX             : IN  STD_LOGIC;
    UART_TX             : OUT STD_LOGIC
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

    COMPONENT seg_disp_driver
    PORT (
        clk                 : IN  STD_LOGIC;
        dig_1_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        dig_2_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        dig_3_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        dig_4_i             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        dp_i                : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
        dots_i              : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
        disp_seg_o          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        disp_dig_o          : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
    END COMPONENT;

    --------------------------------------------------------------------------------
    -- PicoBlaze interface signals
    SIGNAL port_id            : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL write_strobe       : STD_LOGIC;
    SIGNAL k_write_strobe     : STD_LOGIC;
    SIGNAL read_strobe        : STD_LOGIC;
    SIGNAL out_port           : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL in_port            : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL interrupt          : STD_LOGIC;

    SIGNAL LED_reg            : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"00";

    --------------------------------------------------------------------------------

    SIGNAL dig_1_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dig_2_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dig_3_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dig_4_reg          : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dp_reg             : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dots_reg           : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');

    signal pwm_ref_0_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_1_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_2_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_3_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_4_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_5_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_6_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal pwm_ref_7_reg : std_logic_vector(7 downto 0) := (others => '0');
  --------------------------------------------------------------------------------

    -- PicoBlaze address space definition
    CONSTANT ID_BTN           : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"00";
    CONSTANT ID_SW            : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"01";
    CONSTANT ID_LED           : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"02";
    CONSTANT ID_7SEG_DIG_1    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"03";
    CONSTANT ID_7SEG_DIG_2    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"04";
    CONSTANT ID_7SEG_DIG_3    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"05";
    CONSTANT ID_7SEG_DIG_4    : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"06";
    CONSTANT ID_7SEG_DP       : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"07";
    CONSTANT ID_7SEG_DOTS     : STD_LOGIC_VECTOR( 7 DOWNTO 0) := X"08";

    constant ID_PWM_REF_0 : std_logic_vector(7 downto 0) := X"09";
    constant ID_PWM_REF_1 : std_logic_vector(7 downto 0) := X"0A";
    constant ID_PWM_REF_2 : std_logic_vector(7 downto 0) := X"0B";
    constant ID_PWM_REF_3 : std_logic_vector(7 downto 0) := X"0C";
    constant ID_PWM_REF_4 : std_logic_vector(7 downto 0) := X"0D";
    constant ID_PWM_REF_5 : std_logic_vector(7 downto 0) := X"0E";
    constant ID_PWM_REF_6 : std_logic_vector(7 downto 0) := X"0F";
    constant ID_PWM_REF_7 : std_logic_vector(7 downto 0) := X"10";

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- PicoBlaze (KCPSM6 core) with its program memory
  --------------------------------------------------------------------------------

  embedded_kcpsm6_i : ENTITY work.embedded_kcpsm6
  PORT MAP (
    port_id         => port_id,
    write_strobe    => write_strobe,
    k_write_strobe  => k_write_strobe,
    read_strobe     => read_strobe,
    out_port        => out_port,
    in_port         => in_port,
    interrupt       => '0',
    clk             => clk
  );


  --------------------------------------------------------------------------------
  -- 7-segment driver
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP (
    clk                 => CLK,
    dig_1_i             => dig_1_reg,
    dig_2_i             => dig_2_reg,
    dig_3_i             => dig_3_reg,
    dig_4_i             => dig_4_reg,
    dp_i                => dp_reg,
    dots_i              => dots_reg,
    disp_seg_o          => DISP_SEG,
    disp_dig_o          => DISP_DIG
  );


  --------------------------------------------------------------------------------
  -- Input port MUX
  --------------------------------------------------------------------------------

  input_ports: process(clk)
  begin
    if rising_edge(clk) then

      case port_id is
        when ID_BTN                 =>  in_port <= "0000" & BTN;
        when ID_SW                  =>  in_port <= "0000" & SW;

        when ID_LED                 =>  in_port <= LED_reg;

        when ID_7SEG_DIG_1          =>  in_port <= "0000" & dig_1_reg;
        when ID_7SEG_DIG_2          =>  in_port <= "0000" & dig_2_reg;
        when ID_7SEG_DIG_3          =>  in_port <= "0000" & dig_3_reg;
        when ID_7SEG_DIG_4          =>  in_port <= "0000" & dig_4_reg;
        when ID_7SEG_DP             =>  in_port <= "0000" & dp_reg;
        when ID_7SEG_DOTS           =>  in_port <= "00000" & dots_reg;

        -- To ensure minimum logic implementation when defining a multiplexer always
        -- use don't care for any of the unused cases
        when others                 =>  in_port <= "XXXXXXXX";
      end case;
    end if;
  end process input_ports;


  --------------------------------------------------------------------------------
  -- Output port MUX
  --------------------------------------------------------------------------------

  output_ports: process(clk)
  begin
    if rising_edge(clk) then

      if write_strobe = '1' then
        case port_id is
        --   when ID_LED               =>       LED_reg <= out_port;

          when ID_7SEG_DIG_1        =>     dig_1_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DIG_2        =>     dig_2_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DIG_3        =>     dig_3_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DIG_4        =>     dig_4_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DP           =>     dp_reg <= out_port(3 DOWNTO 0);
          when ID_7SEG_DOTS         =>     dots_reg <= out_port(2 DOWNTO 0);

          when ID_PWM_REF_0         =>     pwm_ref_0_reg <= out_port;
          when ID_PWM_REF_1         =>     pwm_ref_1_reg <= out_port;
          when ID_PWM_REF_2         =>     pwm_ref_2_reg <= out_port;
          when ID_PWM_REF_3         =>     pwm_ref_3_reg <= out_port;
          when ID_PWM_REF_4         =>     pwm_ref_4_reg <= out_port;
          when ID_PWM_REF_5         =>     pwm_ref_5_reg <= out_port;
          when ID_PWM_REF_6         =>     pwm_ref_6_reg <= out_port;
          when ID_PWM_REF_7         =>     pwm_ref_7_reg <= out_port;

          when others               =>  NULL;
        end case;
      end if;
    end if;
  end process output_ports;


  pwm_driver_i : entity work.pwm_driver
  port map(
      CLK => clk,
      PWM_REF_0 => pwm_ref_0_reg,
      PWM_REF_1 => pwm_ref_1_reg,
      PWM_REF_2 => pwm_ref_2_reg,
      PWM_REF_3 => pwm_ref_3_reg,
      PWM_REF_4 => pwm_ref_4_reg,
      PWM_REF_5 => pwm_ref_5_reg,
      PWM_REF_6 => pwm_ref_6_reg,
      PWM_REF_7 => pwm_ref_7_reg,
      PWM_OUT => LED_reg,
      CNT_OUT => open
  );

  LED <= LED_reg;

  --------------------------------------------------------------------------------

  UART_TX <= '1';

----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
