----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:25:50 04/09/2015 
-- Design Name: 
-- Module Name:    multi - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( clk,clk_en,vstup : in  STD_LOGIC;
           rst,vystup : out  STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
type state_type is (s0,s1,s2,s3,s4,s5);
signal next_state, present_state : state_type;
signal vs,clken1 : STD_LOGIC;


begin


process(clk) begin
	if rising_edge(clk) then
		present_state <= next_state;
	end if;
	
end process;

process(present_state,vs,clken1,vstup,clk_en) begin
	vs<=vstup;
	clken1<=clk_en;
	
	 case present_state is
				when s0 =>  vystup<='0';
								rst<='0';
								if(vs='1' and clken1='1') then
								next_state<=s1;
								else 
								next_state<=s0;
							  end if;
				
				when s1 => vystup<='0';
								rst<='0';
								if(vs='1' and clken1='1') then
								next_state<=s2;
								elsif(vs='0' and clken1='1') then
								next_state<=s0;
								else
								next_state<=s1;
								end if;
								
				when s2 => vystup<='0';
								rst<='0';
								if(vs='1' and clken1='1') then
								next_state<=s3;
								elsif(vs='0' and clken1='1') then
								next_state<=s0;
								else
								next_state<=s2;
								end if;
								
				when s3 => vystup<='0';
								rst<='0';
								if(vs='1' and clken1='1') then
								next_state<=s4;
								elsif(vs='0' and clken1='1') then
								next_state<=s0;
								else
								next_state<=s3;
								end if;
								
				when s4 => vystup<='1';
								rst<='1';
								if(vs='0') then
								next_state<=s0;
								else
								next_state<=s5;
								end if;
								
				when s5 => vystup<='1';
								rst<='0';
								if(vs='0' and clken1='1') then
								next_state<=s0;
								else
								next_state<=s5;
								end if;

	end case;
	
end process;



				
end Behavioral;

