library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CE_GEN is
	generic(
		DIV_FACT : positive := 1
		);
	port(
		CLK 	: in std_logic;
		SRST 	: in std_logic;
		CE_IN 	: in std_logic;
		CE_OUT 	: out std_logic
		);
end entity;

architecture FULL of CE_GEN is
begin
	
	cnt_gen_i : entity work.CNT_GEN
		generic map(
			MAX_VAL => DIV_FACT,
			LENGTH => 32
		)
		port map(
			CLK => CLK,
			RST => SRST,
			EN => CE_IN,
			CNT_OUT => open,
			OVF => CE_OUT
		);

end architecture;
