--Game Controller
--
-- entity name: g07_game_control
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Antoine Bosselut
-- Date: 11/27/2011

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity g07_game_control is
port(
		clk: in bit;
		st_game: in bit;
		FG: in bit;
		ASPMC_i: in bit;
		SPMC_i: in bit;
		mc_count_i: in std_logic_vector(0 to 4);
		game_control: in bit;

		mc_count: out std_logic_vector(0 to 4);
		NM: out bit;
		ASPMC: out bit;
		SPMC: out bit;
		rst: out bit;
		game_end: out bit

	);
end g07_game_control;
	
architecture a of g07_game_control is
begin
	process(clk, st_game, FG, mc_count_i, ASPMC_i, SPMC_i)
	variable reset: bit;
	variable flag: bit;
	variable count: integer range 0 to 31;
	begin
		if (clk'EVENT and clk = '1') then
			if (st_game = '1') then
				if (not(mc_count_i >= "00000" and mc_count_i <= "11110")) then
					count := 0;
					rst <= '1';
				else
					count := to_integer(unsigned(mc_count_i));
					rst <= '0';
				end if;
				if (count = 0 and flag = '0') then
					rst <= '1';
					flag := '1';
					NM <= '1';
					ASPMC <= '0';
					SPMC <= '1';
				end if;
				if (game_control = '1' and (count = 30 or FG = '1')) then
					NM <= '0';
					ASPMC <= '0';
					SPMC <= '0';
					game_end <= '1';
					count := 0;
					flag := '0';
				elsif (ASPMC_i = '0' and SPMC_i = '1' and game_control = '1') then
					SPMC <= '1';
					ASPMC <= '0';
					NM <= '1';
				elsif(ASPMC_i = '1' and SPMC_i = '0' and game_control = '1') then
					SPMC <= '0';
					ASPMC <= '1';
					NM <= '0';				
				elsif (ASPMC_i = '1' and SPMC_i = '1' and game_control = '1') then
					count := count + 1;
					if (count < 30 and FG = '0') then
						NM <= '1';
						ASPMC <= '0';
						SPMC <= '1';
						game_end <= '0';
					end if;
				end if;
				
				
				mc_count <= std_logic_vector(to_unsigned(count, 5));
			end if;
		end if;
	end process;
end a;