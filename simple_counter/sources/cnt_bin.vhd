----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2022 08:51:13 AM
-- Design Name: 
-- Module Name: cnt_bin - FULL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_bin is
    Port ( CLK      : in STD_LOGIC;
           SRST     : in STD_LOGIC;
           CE       : in STD_LOGIC;
           CNT_LOAD : in STD_LOGIC;
           CNT_UP   : in STD_LOGIC;
           CNT      : out STD_LOGIC_VECTOR (31 downto 0));
end cnt_bin;

architecture FULL of cnt_bin is

    signal cnt_int : unsigned(31 downto 0) := (others => '0');
    -- signal cnt_dir : std_logic; -- 1 = count DOWN, 0 = count UP

begin

    cnt_p : process (CLK)
    begin
        if rising_edge(CLK) then
            if (SRST = '1') then
            
                cnt_int <= (others => '0');
                --cnt_dir <= '0';
                            
            elsif (CE = '1') then
            
                if (CNT_LOAD = '1') then
                    cnt_int <= x"55555555";
                else 
                    if(CNT_UP = '1') then
                        cnt_int <= cnt_int + 1;                       
                    else
                        cnt_int <= cnt_int - 1;                       
                    end if;
                end if;     
            end if; 
        end if;   
    end process;
    
    CNT <= std_logic_vector(cnt_int);

end FULL;
