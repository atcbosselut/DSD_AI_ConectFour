-- entity name: g07_number_to_ascii
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Antoine Bosselut
-- Date:
-- Purpose -- this file serves to convert the row_input and col_input and gra_cell values to ASCII so it can be
--				interpreted by the led_segment decoder.

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g07_number_to_ascii is
port ( 
	row_inp: in std_logic_vector(0 to 2);
	col_inp: in std_logic_vector(0 to 2);
	gra_inp: in std_logic_vector(0 to 1);
	ascii_code_row : out std_logic_vector(6 downto 0);
	ascii_code_col : out std_logic_vector(6 downto 0);
	ascii_code_gra : out std_logic_vector(6 downto 0);
	clk: in bit
	);
end g07_number_to_ascii;

architecture a of g07_number_to_ascii is
begin
		--process(clk)
		--begin
			--if (clk'EVENT and clk = '1') then
			--	if (row_inp = "000") then
			--		ascii_code_row <= "0110000";
				--elsif (row_inp = "001") then
--					--ascii_code_row <= "0110001";
	--			elsif (row_inp = "010") then
		--			ascii_code_row <= "0110010";
			--	elsif (row_inp = "011") then
				--	ascii_code_row <= "0110011";
--				elsif (row_inp = "100") then
	--				ascii_code_row <= "0110100";
		--		elsif (row_inp = "101") then
			--		ascii_code_row <= "0110101";
				--elsif (row_inp = "110") then
					--ascii_code_row <= "0110110";
--				else
	--				ascii_code_row <= "0110111";
		--		end if;
				
		--		if (col_inp = "000") then
			--		ascii_code_col <= "0110000";
				--elsif (col_inp = "001") then
					--ascii_code_col <= "0110001";
--				elsif (col_inp = "010") then
	--				ascii_code_col <= "0110010";
		--		elsif (col_inp = "011") then
			--		ascii_code_col <= "0110011";
				--elsif (col_inp = "100") then
					--ascii_code_col <= "0110100";
--				elsif (col_inp = "101") then
	--				ascii_code_col <= "0110101";
		--		elsif (col_inp = "110") then
			--		ascii_code_col <= "0110110";
				--else
					--ascii_code_col <= "0110111";
--				end if;
				
--				if (gra_inp = "00") then
	--				ascii_code_gra <= "0110000";
		--		elsif (gra_inp = "01") then
			--		ascii_code_gra <= "0110001";
				--elsif (gra_inp = "10") then
					--ascii_code_gra <= "0110010";				
		--		else
		--			ascii_code_gra <= "0110011";
		--		end if;
				ascii_code_row <= "0110000" when (row_inp = "000") else "0110001" when (row_inp = "001") else "0110010" when (row_inp = "010") else "0110011"
								when (row_inp = "011") else "0110100" when (row_inp = "100") else "0110101" when (row_inp = "101") else "0110110" when (row_inp = "110") 
								else "0110111";
				ascii_code_col <= "0110000" when (col_inp = "000") else "0110001" when (col_inp = "001") else "0110010" when (col_inp = "010") else "0110011"
								when (col_inp = "011") else "0110100" when (col_inp = "100") else "0110101" when (col_inp = "101") else "0110110" when (col_inp = "110") 
								else "0110111";
				ascii_code_gra <= "0110000" when (gra_inp = "00") else "0110001" when (gra_inp = "01") else "0110010" when (gra_inp = "10") else "0110011";
			--end if;
	--	end process;
end a;
		
		