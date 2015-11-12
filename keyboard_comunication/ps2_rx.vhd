----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:20:37 10/26/2015 
-- Design Name: 
-- Module Name:    ps2_rx - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2_rx is
    Port ( clk, ps2_c, ps2_d : in  STD_LOGIC;
           ps_out : out  STD_LOGIC_VECTOR (7 downto 0));
end ps2_rx;

architecture Behavioral of ps2_rx is
	--add all used component
	component debouncer is
		 Port ( clk, deb_in : in  STD_LOGIC;
				  deb_out 	 : out  STD_LOGIC);
	end component;
	
	component fallingEdgeDetector is
		 Port ( clk, fall_in : in  STD_LOGIC;
              fall_out : out  STD_LOGIC);
	end component;
	
	--state
	type state_type is (idle, dps, load, ok);
	signal next_state, present_state : state_type;
	
	--registers
	signal reg_deb, reg_fall : STD_LOGIC;
	signal counter : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	signal data_reg, data_out_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
	--use components
	debauncer_inst1 : debouncer 
	port map (clk => clk, deb_in => ps2_c, deb_out => reg_deb);

	fallingEdgeDetector_inst1 : fallingEdgeDetector 
	port map (clk => clk, fall_in => reg_deb, fall_out => reg_fall);


	--and here is state process - memory
	process(clk) begin
		if rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process;
			
	process (present_state, reg_fall, data_reg, ps2_d) begin
		if reg_fall = '1' then
			--first 
			if present_state = idle then
				next_state <= dps;
				--and trash counter
				counter <= (others => '0');
			--else
		--		next_state <=	present_state  ;
			end if;
			--second bock
			if present_state = dps then
			
			
				if counter <= "111" then   --Kde pocita tento counter ??????????????????????????????
			
			
					next_state <= load;	
				end if;
				--push data onto register
				data_reg <= data_reg(6 downto 0) & ps2_d;
			end if;
			
			--last state
			if present_state = load then
				data_out_reg <= data_reg;
				next_state <= ok; 	--there is parit bit
			end if;
			
			if present_state = ok then
				--something with parit bit
				--and go to start
				next_state <= idle;
			end if;
		end if;
	end process;
	
	--and out data
	ps_out <= data_out_reg;
end Behavioral;

