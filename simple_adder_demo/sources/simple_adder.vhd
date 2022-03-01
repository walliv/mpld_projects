------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
------------------------------------------------------
ENTITY simple_adder IS
	GENERIC(
    	WIDTH : positive := 4
    );
  	PORT(
    	A      : IN  STD_LOGIC_VECTOR( WIDTH-1 DOWNTO 0 );
    	B      : IN  STD_LOGIC_VECTOR( WIDTH-1 DOWNTO 0 );
    	Y      : OUT STD_LOGIC_VECTOR( WIDTH-1 DOWNTO 0 );
    	C      : OUT STD_LOGIC;
    	Z      : OUT STD_LOGIC
  	);
END ENTITY simple_adder;
------------------------------------------------------
ARCHITECTURE behavioral OF simple_adder IS

	SIGNAL y_sig    : STD_LOGIC_VECTOR( WIDTH DOWNTO 0 );
    SIGNAL nul_vect : STD_LOGIC_VECTOR( WIDTH downto 0);

BEGIN

	nul_vect_g: for i in WIDTH downto 0 generate
    	nul_vect(i) <= '0';    
    end generate;

  Z <= '1' WHEN (y_sig(Y'range) = nul_vect(nul_vect'high-1 downto 0)) ELSE '0';
  
  C <= y_sig(y_sig'high);
  Y <= y_sig(Y'range);
  
  y_sig <= STD_LOGIC_VECTOR( unsigned(nul_vect) + UNSIGNED(A) + UNSIGNED(B) );

END ARCHITECTURE;
------------------------------------------------------
