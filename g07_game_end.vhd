-- Determining the row configuration of disks store in ASP or SP registers
--
-- entity nameL g07_game_end
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Antoine Bosselut
-- Date: 15/11/2011

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g07_game_end is
port(
		clk: in bit;
		mc_count: in std_logic_vector(0 to 4);
		asp_length: in std_logic_vector(0 to 2);
		game_end: in bit;
		
		ascii1: out std_logic_vector(0 to 6);
		ascii2: out std_logic_vector(0 to 6);
		ascii3: out std_logic_vector(0 to 6);
		ascii4: out std_logic_vector(0 to 6)
);
end g07_game_end;

architecture a of g07_game_end is
begin
	process(clk, mc_count, asp_length, game_end)
	begin
		if (game_end = '1') then				
			if (asp_length = "100") then
				ascii1 <= std_logic_vector(to_unsigned(76, 7));
				ascii2 <= std_logic_vector(to_unsigned(79, 7));
				ascii3 <= std_logic_vector(to_unsigned(83, 7));
				ascii4 <= std_logic_vector(to_unsigned(69, 7));
			else
				ascii1 <= std_logic_vector(to_unsigned(84, 7));
				ascii2 <= std_logic_vector(to_unsigned(73, 7));
				ascii3 <= std_logic_vector(to_unsigned(69, 7));
				ascii4 <= std_logic_vector(to_unsigned(0, 7));
			end if;
		else
			ascii1 <= std_logic_vector(to_unsigned(80, 7));
			ascii2 <= std_logic_vector(to_unsigned(76, 7));
			ascii3 <= std_logic_vector(to_unsigned(65, 7));
			ascii4 <= std_logic_vector(to_unsigned(89, 7));
		end if;
	end process;
end;