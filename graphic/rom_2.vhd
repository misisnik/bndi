----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:22:41 11/12/2015 
-- Design Name: 
-- Module Name:    rom_1 - Behavioral 
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_2 is
    Port ( address_a : in  STD_LOGIC_VECTOR (11 downto 0);
			  address_b : in  STD_LOGIC_VECTOR (11 downto 0);
           clk : in STD_LOGIC;
			  data_a : out  STD_LOGIC_VECTOR (3 downto 0);
			  data_b : out  STD_LOGIC_VECTOR (3 downto 0));
end rom_2;

--rom 2 obsahuje 64bitove obrazky coz uz je maso :D
architecture Behavioral of rom_2 is
	--graphic database
	type rom_type is array(0 to 4095) of std_logic_vector(3 downto 0);
	constant database : rom_type :=
	(
		--prekazka je tu vertikalne
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "0000", "0000", "0000", "0000", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "0000", "0000", "0000", "0000", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "0000", "0000", "0000", "0000", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "0000", "0000", "0000", "0000", "0000", "0010", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0010", "0010", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011",
		--zbran na retezu 1
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "1011", "1011", "1011", 
		"1011", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "0000", "0111", "0111", "0000", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", 
		"1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "0000", "0111", "0111", "0000", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", 
		"1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "1011", 
		"1011", "1011", "1011", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "1111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011",
		--zbran na retezu 2
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "0000", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "1111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "0000", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011",
		--cloud
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "0000", "0000", "0111", "0111", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "0000", "0000", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", 
		"1011", "1011", "1011", "0000", "0000", "0000", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", 
		"1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", 
		"1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", 
		"0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", 
		"0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", 
		"1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "1011", 
		"1011", "1011", "1011", "0000", "0111", "0111", "0111", "0111", "0111", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "0000", "0111", "0111", "0111", "0111", "0111", "0111", "0111", "0000", "0000", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "0000", "0111", "0111", "0111", "0000", "1011", "0000", "0000", "0111", "0111", "0111", "0111", "0000", "1011", "1011", "0000", "0000", "0111", "0111", "0111", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "0000", "0000", "0000", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", 
		"1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011", "1011"
				

	);
begin
	process (clk)
	begin
		if (clk'event and clk = '1') then
			data_a <= database(to_integer(unsigned(address_a)));
			data_b <= database(to_integer(unsigned(address_b)));
		end if;
	end process;



end Behavioral;
