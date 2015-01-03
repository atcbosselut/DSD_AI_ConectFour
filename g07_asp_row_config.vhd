-- Determining the row configuration of disks stored in ASP or SP registers
--
-- entity name: g07_row_config
--
-- Copyright (C) 2011
-- Version 1.0
-- Author: Antoine Bosselut and Irtaza Rizvi
-- Date: 10/04/2011

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use work.lab_package.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package lab_package is
type r_vector is array(0 to 3) of std_logic_vector(0 to 2);
type r_vector_array is array(0 to 7) of r_vector;
end lab_package;

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use work.lab_package.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity g07_asp_row_config is
	port ( rst: in bit;
			ASP_r_i, ASP_c_i: in r_vector;
			clk: in bit;
			control: in bit;
			horiz, vertic, l_r_diag, r_l_diag: out bit;
			one_insert: out bit);
end g07_asp_row_config;

architecture a of g07_asp_row_config is
begin
	process(ASP_r_i, ASP_c_i, clk, control, rst)
	variable horizontal: bit;
	variable vertical: bit;
	variable l_r_diagonal: bit;
	variable r_l_diagonal: bit;
	variable test: bit;
	variable flag: std_logic_vector(0 to 1);
	begin		
		if(clk'EVENT and clk = '1' and control = '1')	then
			if (rst = '1') then
				flag := "00";			
			elsif (flag = "00")	then
				test := '0';
				if (ASP_r_i(0) = ASP_r_i(1)) and (ASP_c_i(0) = (ASP_c_i(1) - 1)) then
					horizontal := '1';
				else 
					horizontal := '0';
				end if;
				
				if (ASP_r_i(0) = (ASP_r_i(1) - 1)) and (ASP_c_i(0) = ASP_c_i(1)) then
					vertical := '1';
				else 
					vertical := '0';
				end if;
						  
				if (ASP_r_i(0) = (ASP_r_i(1) - 1)) and (ASP_c_i(0) = (ASP_c_i(1) + 1)) then 
					l_r_diagonal := '1';
				else 
					l_r_diagonal := '0';
				end if;
							
				if (ASP_r_i(0) = (ASP_r_i(1) - 1)) and (ASP_c_i(0) = (ASP_c_i(1) - 1)) then
					r_l_diagonal := '1';
				else 
					r_l_diagonal := '0';
				end if;
				
				if (horizontal = '0' and vertical = '0' and l_r_diagonal = '0' and r_l_diagonal = '0' and ASP_r_i(1) = "111" and ASP_r_i(0) /= "111") then
					test := '1';
				end if;
				flag := "01";
			elsif(flag = "01") then
				flag := "10";
			elsif(flag = "10") then
				flag := "00";
			end if;
		end if;
		horiz <= horizontal;
		vertic <= vertical;
		l_r_diag <= l_r_diagonal;
		r_l_diag <= r_l_diagonal;
		one_insert <= test;
	end process;
		
end a;