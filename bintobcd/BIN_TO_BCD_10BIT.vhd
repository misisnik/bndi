
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity BIN_TO_BCD_12BIT is
    Port ( clk 			: in STD_LOGIC;
			  reset			: in STD_LOGIC;
			  clk_en 		: in STD_LOGIC:= ('1');
			  Binarni_skore: in  STD_LOGIC_VECTOR (11 downto 0);
           BCD_Jednotky : out  STD_LOGIC_VECTOR (3 downto 0);
           BCD_Desitky 	: out  STD_LOGIC_VECTOR (3 downto 0);
           BCD_Stovky 	: out  STD_LOGIC_VECTOR (3 downto 0);
           BCD_Tisice 	: out  STD_LOGIC_VECTOR (3 downto 0));
end BIN_TO_BCD_12BIT;

architecture Behavioral of BIN_TO_BCD_12BIT is

signal D_klop_jednotky 	: std_logic_vector (3 downto 0)	:= ("0000");
signal Q_klop_jednotky 	: std_logic_vector (3 downto 0)	:= ("0000");
signal D_klop_desitky 	: std_logic_vector (3 downto 0)	:= ("0000");
signal Q_klop_desitky 	: std_logic_vector (3 downto 0)	:= ("0000");
signal D_klop_stovky 	: std_logic_vector (3 downto 0)	:= ("0000");
signal Q_klop_stovky 	: std_logic_vector (3 downto 0)	:= ("0000");
signal D_klop_tisice 	: std_logic_vector (3 downto 0)	:= ("0000");
signal Q_klop_tisice 	: std_logic_vector (3 downto 0)	:= ("0000");
signal Q_BIN_cislo		: std_logic_vector (11	downto 0):= ("000000000000");
signal D_BIN_cislo		: std_logic_vector (11	downto 0):= ("000000000000");


signal spusteno 			: STD_LOGIC	:= '1';
signal cyklu   			: natural	:= 0;


begin



process(clk)
begin
	if(clk'event and clk='1') then
		if(reset = '1') then
		 
			BCD_Jednotky<="0000";
			BCD_Desitky	<="0000";
			BCD_Stovky	<="0000";
			BCD_Tisice	<="0000";
			
			--BIN_cislo<= others '0';
			
		elsif(clk_en = '1') then
		 
			BCD_Jednotky<=D_klop_jednotky;
			BCD_Desitky<=D_klop_desitky;
			BCD_Stovky<=D_klop_stovky;
			BCD_Tisice<=D_klop_tisice;
		 
			if(spusteno = '0')then
				Q_BIN_cislo<=Binarni_skore;
				spusteno <= '1';
			end if;	
		end if;
		
		if(spusteno = '1') then
			Q_BIN_cislo<=D_BIN_cislo;
			cyklu<=cyklu+1;
				if(cyklu > 9 ) then -- Provede 12 cyklu --  9 nechtej vedet proc
					spusteno <='0';
					cyklu <= 0;
				end if;				
		end if;	
		
	end if;
end process;


process(clk)
begin
  if(clk'event and clk='1') then
  
		if(reset = '1') then
		 
			Q_klop_jednotky<="0000";
			Q_klop_desitky<="0000";
			Q_klop_tisice<="0000";
			Q_klop_tisice<="0000";
			
		elsif(spusteno = '1') then
			if(D_klop_jednotky>"0100")then -- vìtší než 4
				Q_klop_jednotky<=std_logic_vector(unsigned(D_klop_jednotky)+3);
			else
				Q_klop_jednotky<=D_klop_jednotky;
			end if;
			
			if(D_klop_desitky>"0100")then -- vìtší než 4
				Q_klop_desitky<=std_logic_vector(unsigned(D_klop_desitky)+3);
			else
				Q_klop_desitky<=D_klop_desitky;
			end if;
			
			if(D_klop_stovky>"0100")then -- vìtší než 4
				Q_klop_stovky<=std_logic_vector(unsigned(D_klop_stovky)+3);
			else
				Q_klop_stovky<=D_klop_stovky;
			end if;
			
			if(D_klop_tisice>"0100")then -- vìtší než 4
				Q_klop_tisice<=std_logic_vector(unsigned(D_klop_tisice)+3);
			else
				Q_klop_tisice<=D_klop_tisice;
			end if;
		end if;
		
		if(clk_en = '1') then
			Q_klop_jednotky<="0000";
			Q_klop_desitky<="0000";
			Q_klop_tisice<="0000";
			Q_klop_tisice<="0000";
		end if;
  end if;
end process;

D_BIN_cislo(11 downto 0)<=Q_BIN_cislo(10 downto 0)& Q_BIN_cislo(11);

D_klop_jednotky(0)<=Q_BIN_cislo(11);
D_klop_jednotky(3 downto 1)<=Q_klop_jednotky(2 downto 0);

D_klop_desitky(0)<=Q_klop_jednotky(3);
D_klop_desitky(3 downto 1)<=Q_klop_desitky(2 downto 0);

D_klop_stovky(0)<=Q_klop_desitky(3);
D_klop_stovky(3 downto 1)<=Q_klop_stovky(2 downto 0);

D_klop_tisice(0)<=Q_klop_stovky(3);
D_klop_tisice(3 downto 1)<=Q_klop_tisice(2 downto 0);


end Behavioral;

