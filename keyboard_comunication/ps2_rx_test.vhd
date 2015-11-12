--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:24:55 10/26/2015
-- Design Name:   
-- Module Name:   C:/Users/xslade18/Desktop/bndi-master/keyboard_comunication/ps2_rx_test.vhd
-- Project Name:  keyboard_comunication
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ps2_rx
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ps2_rx_test IS
END ps2_rx_test;
 
ARCHITECTURE behavior OF ps2_rx_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ps2_rx
    PORT(
         clk : IN  std_logic;
         ps2_c : IN  std_logic;
         ps2_d : IN  std_logic;
         ps_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ps2_c : std_logic := '0';
   signal ps2_d : std_logic := '0';

 	--Outputs
   signal ce : std_logic;
   signal ps_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant clk_period2 : time := 33.33 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ps2_rx PORT MAP (
          clk => clk,
          ps2_c => ps2_c,
          ps2_d => ps2_d,
          ps_out => ps_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	clk_process2 :process
   begin
		ps2_c <= '0';
		wait for clk_period2/2;
		ps2_c <= '1';
		wait for clk_period2/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		--set
		ps2_d <= '1';
		wait for 33.33 us;
		ps2_d <= '1';
		wait for 33.33 us;
		ps2_d <= '0';
		wait for 33.33 us;
		ps2_d <= '1';
		wait for 33.33 us;
		ps2_d <= '1';
		wait for 33.33 us;
		ps2_d <= '1';
		wait for 33.33 us;
		ps2_d <= '1';
		wait for 33.33 us;
		ps2_d <= '0';
		wait for 33.33 us;
		ps2_d <= '1';
		wait for 33.33 us;
		
      wait for clk_period*10;
		 wait for clk_period2*10;

      -- insert stimulus here 

      wait;
   end process;

END;
