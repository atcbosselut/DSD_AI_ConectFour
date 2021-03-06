-- Determining the row configuration of disks stored in ASP or SP registers
--
-- entity name: gNN_gra_arr
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Antoine Bosselut
-- Date:
library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package lab_package3 is
type array_row is array(0 to 6) of std_logic_vector(0 to 1);

type gra_arr is array(0 to 5) of array_row;

end lab_package3;

 
library ieee;
use ieee.std_logic_1164.all;
use work.lab_package3.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity g07_gra_arr is
port(
row_inp_asp: in integer range 0 to 5;
col_inp_asp: in integer range 0 to 6;
row_inp_sp: in integer range 0 to 5;
col_inp_sp: in integer range 0 to 6;
readwrite_asp: in bit;
readwrite_sp: in bit;
control_asp: in bit;
control_sp: in bit;
gra_in_asp: in std_logic_vector(0 to 1);
gra_in_sp: in std_logic_vector(0 to 1);
clk: in bit;
gra_rst: in bit;
gra_out_cell: out std_logic_vector(0 to 1);
gra_out_row_0: out array_row;
gra_out_row_1: out array_row;
gra_out_row_2: out array_row;
gra_out_row_3: out array_row;
gra_out_row_4: out array_row;
gra_out_row_5: out array_row;
SPMC: out bit;
ASPMC: out bit;
game_control: out bit
--gra_out_array: out gra_arr
);
end g07_gra_arr;

architecture a of g07_gra_arr is
BEGIN
	PROCESS (clk, gra_rst, row_inp_asp, row_inp_sp, col_inp_asp, col_inp_sp, gra_in_asp, gra_in_sp, readwrite_asp, 
				readwrite_sp, control_sp, control_asp)
	variable temp_gra: gra_arr;
	variable row_inp: integer range 0 to 5;
	variable col_inp: integer range 0 to 6; 
	variable game_c: bit;
	BEGIN		
		IF (gra_rst='1') THEN
			--reset all gra array cells to "00"
			FOR i in 0 to 5 LOOP
				FOR j in 0 to 6 LOOP
					temp_gra(i)(j):="00";
				END LOOP;
			END LOOP;
		ELSIF (clk 'EVENT AND clk='1') THEN
			game_c := '0';
			IF (control_asp = '1') THEN
				row_inp := row_inp_asp;
				col_inp := col_inp_asp;
				IF (readwrite_asp = '0') THEN
					temp_gra(row_inp)(col_inp):=gra_in_asp;
					game_c := '1';
					ASPMC <= '1';
					SPMC <= '0';
				END IF;
			ELSIF (control_sp = '1') THEN
				row_inp := row_inp_sp;
				col_inp := col_inp_sp;
				IF (readwrite_sp = '0') THEN
					temp_gra(row_inp)(col_inp):=gra_in_sp;
					game_c := '1';
					SPMC <= '1';
					ASPMC <= '1';
				END IF;
			END IF;
			gra_out_cell <= temp_gra(row_inp)(col_inp);
			game_control <= game_c;
		END IF;
		gra_out_row_0 <= temp_gra(0);
		gra_out_row_1 <= temp_gra(1);
		gra_out_row_2 <= temp_gra(2);
		gra_out_row_3 <= temp_gra(3);
		gra_out_row_4 <= temp_gra(4);
		gra_out_row_5 <= temp_gra(5);
	END PROCESS;
end a;