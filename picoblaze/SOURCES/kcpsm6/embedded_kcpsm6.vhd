------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------
entity embedded_kcpsm6 is
    Port (      port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
         k_write_strobe : out std_logic;
            read_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
                in_port : in std_logic_vector(7 downto 0);
              interrupt : in std_logic;
                    clk : in std_logic);
end embedded_kcpsm6;
------------------------------------------------------------------------------------
architecture connectivity of embedded_kcpsm6 is
------------------------------------------------------------------------------------

  component kcpsm6
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

  ----------------------------------------------------------------------------------

  component prog_ROM
    generic(             C_FAMILY : string := "S6";
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0;
                     C_JTAG_CHAIN : integer := 3);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;
                    clk : in std_logic);
  end component;

------------------------------------------------------------------------------------

  signal         address : std_logic_vector(11 downto 0);
  signal     instruction : std_logic_vector(17 downto 0);
  signal     bram_enable : std_logic;
  signal    kcpsm6_reset : std_logic;

------------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------------

  processor: kcpsm6
    generic map (                 hwbuild => X"00",
                         interrupt_vector => X"FFF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => OPEN,
                     sleep => '0',
                     reset => kcpsm6_reset,
                       clk => clk);

  ----------------------------------------------------------------------------------

  program_rom: prog_ROM                          --Name to match your PSM file
    generic map(             C_FAMILY => "7S",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 4,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1,      --Include JTAG Loader when set to '1'
                         C_JTAG_CHAIN => 3)      --select BSACN component (1-4); change reload command accordingly
                                                 -- (JTAG_Loader_Win7_64.exe -i3 -l prog_ROM.hex)
                                                 --                            A
    port map(      address => address,
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);

------------------------------------------------------------------------------------
end connectivity;
------------------------------------------------------------------------------------
