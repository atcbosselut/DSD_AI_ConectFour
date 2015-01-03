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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity g07_row_config is
	port ( ASP_r_i, ASP_c_i: in std_logic_vector(0 to 11);
			horiz, vertic, l_r_diag, r_l_diag: out bit);
end g07_row_config;

architecture a of g07_row_config is
begin
	horiz <= '1' when (ASP_r_i(0 to 2) = ASP_r_i(3 to 5)) and (ASP_c_i(0 to 2) = (ASP_c_i(3 to 5) - 1)) else
			 '1' when (ASP_r_i(3 to 5) = "111") else
			 '0';
	
	vertic <= '1' when (ASP_r_i(0 to 2) = (ASP_r_i(3 to 5) - 1)) and (ASP_c_i(0 to 2) = ASP_c_i(3 to 5)) else
			  '0';
			  
	l_r_diag <= '1' when (ASP_r_i(0 to 2) = (ASP_r_i(3 to 5) - 1)) and (ASP_c_i(0 to 2) = (ASP_c_i(3 to 5) + 1)) else
				'0';
				
	r_l_diag <= '1' when (ASP_r_i(0 to 2) = (ASP_r_i(3 to 5) - 1)) and (ASP_c_i(0 to 2) = (ASP_c_i(3 to 5) - 1)) else
				'0';
end a;