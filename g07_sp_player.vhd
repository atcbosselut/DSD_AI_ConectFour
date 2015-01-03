-- entity name: g07_sp_player
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Antoine Bosselut and Irtaza Rizvi
-- Date:
library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity g07_sp_player is
port(
row_in: in integer range 0 to 5;
col_in: in integer range 0 to 6;
asp_rst: in bit;
control: in bit;

-- I/O ports for communication with the GRA array
row_inp: out integer range 0 to 5;
col_inp: out integer range 0 to 6;
clk: in bit;
gra_out: in std_logic_vector(0 to 1);
gra_in: out std_logic_vector(0 to 1);

-- other output signals from SP Next Move routine
SPMC: out bit;
readwrite: out bit


);
end g07_sp_player;

architecture a of g07_sp_player is
BEGIN
	PROCESS (clk,asp_rst, control)
	BEGIN
		IF (asp_rst='1') THEN
			gra_in <="11";
			SPMC <='0';
			readwrite <= '1';
		ELSIF (clk 'EVENT AND clk='1' and control = '1') THEN
			IF (gra_out = "00") THEN
				row_inp <= row_in;
				col_inp <= col_in;
				SPMC <= '1';
				readwrite <= '0';
				gra_in <= "11";
			ELSE 
				SPMC <= '0';			
				readwrite <= '1';
				gra_in <= gra_out;
				row_inp <= row_in;
				col_inp <= col_in;
			END IF;
		END IF;


	END PROCESS;
end a;