----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT (
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT (
    clk             : IN  STD_LOGIC;
    dig_1_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_2_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_3_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dig_4_i         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    dp_i            : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    dots_i          : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    disp_seg_o      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    disp_dig_o      : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

    signal cnt_o : std_logic_vector(31 downto 0) := (others => '0');



----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

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
  PORT MAP (
    clk                 => CLK,
    dig_1_i             => cnt_o(31 downto 28),
    dig_2_i             => cnt_o(27 downto 24),
    dig_3_i             => cnt_o(23 downto 20),
    dig_4_i             => cnt_o(19 downto 16),
    dp_i                => "0000",
    dots_i              => "011",
    disp_seg_o          => DISP_SEG,
    disp_dig_o          => DISP_DIG
  );

  --------------------------------------------------------------------------------

  cnt_bin_i : entity work.cnt_bin
  port map(
    CLK         => CLK,
    SRST        => BTN(0),
    CE          => SW(3),
    CNT_LOAD    => BTN(1),
    CNT_UP      => SW(2),
    CNT         => cnt_o);
   
  LED <= cnt_o(31 downto 24);


----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
