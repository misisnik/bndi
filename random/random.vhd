library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity random is
    Port ( 	
				clk 		: in  std_logic; 
				PSU 		: out STD_LOGIC_VECTOR (3 downto 0);
				NEW_SEED : in std_logic_vector (15 downto 0)			--Dotateèná funkce pøizazením signálu o 16 Bitech se hodnota signálu naète jako nový SEED
				
			);
end random;

architecture Behavioral of random is

signal D_klop : std_logic_vector (15 downto 0);
signal Q_klop_G : std_logic_vector (15 downto 0);
signal Q_klop : std_logic_vector (15 downto 0):= ("1000000000000000"); --SEED number nikdy nesmí být nula -> na výstupu poøád nuly

signal Seed_change_enable_D : boolean;
signal Seed_change_enable_Q : boolean;
signal SEED : std_logic_vector (15 downto 0):= ("1100100000101011");


begin

	process(clk) begin
			if rising_edge(clk)then
				Q_klop <= D_klop;
				Seed_change_enable_Q<=Seed_change_enable_D;
			end if;

	end process;
	
	process(clk) begin
			if rising_edge(clk) and (SEED/=NEW_SEED) then
				SEED<=NEW_SEED;
			end if;
	end process;

Seed_change_enable_D <= (SEED /=NEW_SEED) and (NEW_SEED /= "0000000000000000") ;
Q_klop_G<= NEW_SEED when Seed_change_enable_Q =true  else  Q_klop;	
			


---------------------------------------------------------------
--Realizace generátoru Galois LFSRs s 3 XORy-------------------
D_klop	(15 downto 14) <= Q_klop_G(0) & Q_klop_G(15);
D_klop	(13)  			<= (Q_klop_G(14) xor Q_klop_G(0));
D_klop	(12)  			<= (Q_klop_G(13) xor Q_klop_G(0));
D_klop	(11 downto 10) <= Q_klop_G(12) & (Q_klop_G(11) xor Q_klop_G(0));
D_klop	(9  downto 0 ) <= Q_klop_G(10 downto 1);
---------------------------------------------------------------


---------------------------------------------------------------
--Výstup náhodného 8 bitového èísla----------------------------
PSU <= Q_klop (7 downto 4);
---------------------------------------------------------------
end Behavioral;
