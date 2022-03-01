------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
------------------------------------------------------
ENTITY simple_adder_tb IS
END ENTITY simple_adder_tb;
------------------------------------------------------
ARCHITECTURE tb OF simple_adder_tb IS

  COMPONENT simple_adder
  PORT(
    A      : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    B      : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    Y      : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 );
    C      : OUT STD_LOGIC;
    Z      : OUT STD_LOGIC
  );
  END COMPONENT;

  SIGNAL a_sig      : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
  SIGNAL b_sig      : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
  SIGNAL y_sig      : STD_LOGIC_VECTOR( 3 DOWNTO 0 );
  SIGNAL c_sig      : STD_LOGIC;
  SIGNAL z_sig      : STD_LOGIC;
  
  signal err_cntr : integer := 0;

BEGIN

  uut_i : simple_adder
  PORT MAP(
    A      => a_sig,
    B      => b_sig,
    Y      => y_sig,
    C      => c_sig,
    Z      => z_sig
  );


  -- stimulus generator
  stim_p: PROCESS
  BEGIN
  	b_sig <= "0000";
  
  	for i in 0 to 15 loop
    	for j in 0 to 15 loop
    		a_sig <= std_logic_vector(to_unsigned(i,4));
        	b_sig <= std_logic_vector(to_unsigned(j,4));
        	wait for 10 ns;
        end loop;    
    end loop;
  
    a_sig <= X"F";
    b_sig <= X"F";
    WAIT FOR 10 ns;
    
    WAIT;
  END PROCESS;
  	
	output_checker_p : process --(a_sig,b_sig)
    
    	variable y_ref : unsigned(y_sig'length downto 0);
        variable c_ref : std_logic;
        variable z_ref : std_logic;
        
  	begin
    
    	wait on a_sig, b_sig;
        wait for 1 ns;
		
        y_ref := "00000" + unsigned(a_sig) + unsigned(b_sig);
        c_ref := y_ref(y_ref'high);
        
        if (y_ref(3 downto 0) = "0000") then
        	z_ref := '1';
        else 
        	z_ref := '0';
        end if;
        
        if (z_ref /= z_sig or c_ref /= c_sig or (y_ref(3 downto 0) /= unsigned(y_sig))) then
        	err_cntr <= err_cntr + 1;
        end if;
        
        assert (z_ref = z_sig) report
        	"Error in the funtctionality of the Zero (Z) output signal! Expected Z = " &
            STD_LOGIC'image(z_ref) &
            ", actual is: " &
            STD_LOGIC'image(z_sig) &
            " (inputs A = " &
            INTEGER'image(to_integer(unsigned(a_sig))) &
            ", B = " &
            INTEGER'image(to_integer(unsigned(b_sig))) &
            ")"
            severity error;
           
        assert (c_ref = c_sig) report
       		"Error in the funtionality of the Carry (C) signal! Expected C = " &
            STD_LOGIC'image(c_ref) &
            ", actual is: " &
            STD_LOGIC'image(c_sig) &
            " (inputs A = " &
            INTEGER'image(to_integer(unsigned(a_sig))) &
            ", B = " &
            INTEGER'image(to_integer(unsigned(b_sig))) &
            ")"
            severity error;
        
        assert (y_ref(3 downto 0) = unsigned(y_sig)) report
        	"Error, expected Y = " &
           	INTEGER'image(to_integer(y_ref(3 downto 0))) &
            ", actual is: " &
            INTEGER'image(to_integer(unsigned(y_sig))) &
            " (inputs A = " &
            INTEGER'image(to_integer(unsigned(a_sig))) &
            ", B = " &
            INTEGER'image(to_integer(unsigned(b_sig))) &
            ")"
            severity error;
  
  	end process;
    
   	fin_p : process
    begin 
    
    	wait until (a_sig = "1111" and b_sig = "1111");
        wait for 10 ns;
        
        if(err_cntr /= 0) then
            report "Test FAILED! The amount of errors: " & INTEGER'image(err_cntr);        
        else
            report "Test PASSED! There are zero errors.";        
        end if;
    
    end process;

END ARCHITECTURE;
------------------------------------------------------
