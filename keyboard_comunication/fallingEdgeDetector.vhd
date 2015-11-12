----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:30:36 10/26/2015 
-- Design Name: 
-- Module Name:    fallingEdgeDetector - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fallingEdgeDetector is
    Port ( clk, fall_in : in  STD_LOGIC;
           fall_out : out  STD_LOGIC);
end fallingEdgeDetector;

architecture Behavioral of fallingEdgeDetector is
	signal reg_o, reg_xor, reg_and : STD_LOGIC;
begin

	process (clk) begin
		if rising_edge(clk) then
			reg_o <= fall_in;
			fall_out <= reg_and;
		end if;
	end process;

	reg_xor <= fall_in xor reg_o;
	reg_and <= not fall_in and reg_xor;

end Behavioral;

