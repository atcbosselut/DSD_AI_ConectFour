-- Determining the row configuration of disks stored in ASP or SP registers 
--
-- entity name: g07_longest_row
--
-- Copyright (C) 2011 
-- Version 1.0
-- Author: Antoine Bosselut
-- Date: 09/27/2011

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--package package1 is
	--type numb_3_bit is range 0 to 7;
--end package package1;

entity g07_longest_row is
port(ASP_r_0, ASP_r_1, ASP_r_2, ASP_r_3: in std_logic_vector(0 to 11);
ASP_r_4, ASP_r_5, ASP_r_6, ASP_r_7: in std_logic_vector(0 to 11);
ASP_c_0, ASP_c_1, ASP_c_2, ASP_c_3: in std_logic_vector(0 to 11);
ASP_c_4, ASP_c_5, ASP_c_6, ASP_c_7: in std_logic_vector(0 to 11);
ASP_dr: in std_logic_vector(0 to 7);
ASP_empty: in std_logic_vector(0 to 7);
NM: in bit;
ASP_lrow: out std_logic_vector(0 to 2));
end g07_longest_row;

architecture a of g07_longest_row is
begin
process(ASP_r_0, ASP_r_1, ASP_r_2, ASP_r_3, ASP_r_4, ASP_r_5, ASP_r_6, ASP_r_7,
		ASP_c_0, ASP_c_1, ASP_c_2, ASP_c_3, ASP_c_4, ASP_c_5, ASP_c_6, ASP_c_7,
		ASP_dr, ASP_empty, NM)
	--variable ASPMC: integer := 0;
	variable no_cells: std_logic_vector(0 to 2) := "000";
	variable ASP_length: std_logic_vector(0 to 2) := "000";
	variable lrow: integer range 0 to 7 := 0;
	variable ASP_r_i, ASP_c_i: std_logic_vector(0 to 11);
begin
	ASP_length :="000";
	lrow := 0;
	if NM = '1' then
		for i in 0 to 7 loop
			if ASP_dr(i) = '0' then
				if ASP_empty(i) = '0' then
					no_cells := "000";
					case i is
						when 0 =>
							ASP_r_i := ASP_r_0;
							ASP_c_i := ASP_c_0;
						when 1 =>
							ASP_r_i := ASP_r_1;
							ASP_c_i := ASP_c_1;
						when 2 =>
							ASP_r_i := ASP_r_2;
							ASP_c_i := ASP_c_2;
						when 3 =>
							ASP_r_i := ASP_r_3;
							ASP_c_i := ASP_c_3;
						when 4 =>
							ASP_r_i := ASP_r_4;
							ASP_c_i := ASP_c_4;
						when 5 =>
							ASP_r_i := ASP_r_5;
							ASP_c_i := ASP_c_5;
						when 6 =>
							ASP_r_i := ASP_r_6;
							ASP_c_i := ASP_c_6;
						when 7 =>
							ASP_r_i := ASP_r_7;
							ASP_c_i := ASP_c_7;
					end case;
					for j in 0 to 3 loop
						if ASP_r_i(3*j to 3*j + 2) /= "111" then
							no_cells := no_cells + "001";
						end if;
						
						if no_cells > ASP_length then
							ASP_length := no_cells;
							lrow := i;
						end if;
					end loop;
				end if;
			end if;
		end loop;
		case lrow is
			when 0 =>
				ASP_r_i := ASP_r_0;
				ASP_c_i := ASP_c_0;
			when 1 =>
				ASP_r_i := ASP_r_1;
				ASP_c_i := ASP_c_1;
			when 2 =>
				ASP_r_i := ASP_r_2;
				ASP_c_i := ASP_c_2;
			when 3 =>
				ASP_r_i := ASP_r_3;
				ASP_c_i := ASP_c_3;
			when 4 =>
				ASP_r_i := ASP_r_4;
				ASP_c_i := ASP_c_4;
			when 5 =>
				ASP_r_i := ASP_r_5;
				ASP_c_i := ASP_c_5;
			when 6 =>
				ASP_r_i := ASP_r_6;
				ASP_c_i := ASP_c_6;
			when 7 =>
				ASP_r_i := ASP_r_7;
				ASP_c_i := ASP_c_7;
		end case;
	end if;
	ASP_lrow <= std_logic_vector(to_unsigned(lrow, 3));
			
			
			
	end process;		
end a;

