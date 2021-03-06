-- Determining the row configuration of disks stored in ASP or SP registers 
--
-- entity name: g07_row_incr_config
--
-- Copyright (C) 2011 -- Version 1.0
-- Author: Irtaza Rizvi
-- Date: 10/21/2011
 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package lab_package4 is
type r_vector is array(0 to 3) of std_logic_vector(0 to 2);
type array_row is array(0 to 6) of std_logic_vector(0 to 1);
type gra_array is array(0 to 5) of array_row;

end lab_package4;

 
library ieee;
use ieee.std_logic_1164.all;
use work.lab_package4.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity g07_asp_row_incr is
port(
	clk: in bit;
	horizont, vertic, l_r_diag, r_l_diag: in bit;
	ASP_i_r, ASP_i_c: in r_vector;
	ASP_lrow: in std_logic_vector(0 to 2);
	ASP_dr_i: in bit_vector(0 to 7);
	one_insert: in bit;
	gra_in_row_0: in array_row;
	gra_in_row_1: in array_row;
	gra_in_row_2: in array_row;
	gra_in_row_3: in array_row;
	gra_in_row_4: in array_row;
	gra_in_row_5: in array_row;
	row_inp_o: out integer range 0 to 5;
	col_inp_o: out integer range 0 to 6;
	ASP_empty: in bit_vector(0 to 7);
	no_reg: out bit;
	control: in bit;
	rst: in bit;
	
	ASP_o_r, ASP_o_c: out r_vector;
	asp_reg_id: out integer range 0 to 7;
	disk_ins: out bit; 
	no_ins: out bit;
	ASP_dr: out bit_vector(0 to 7);
	gra_out_cell: out std_logic_vector(0 to 1);
	readwrite: out bit

	
	);
	
end g07_asp_row_incr;
 
architecture a of g07_asp_row_incr is
BEGIN
	PROCESS(horizont, vertic, l_r_diag, r_l_diag, ASP_i_c, ASP_i_r, ASP_lrow, ASP_dr_i, clk, gra_in_row_0, gra_in_row_1, gra_in_row_2, gra_in_row_3,
			gra_in_row_4, gra_in_row_5, control, rst)
	variable r0,c0,c1,r1: std_logic_vector(2 downto 0);
	variable temp_gra: gra_array;
	variable r_n0, r_n1: integer range 0 to 5 := 0;
	variable c_n0, c_n1: integer range 0 to 6 := 0;
	variable tempASP_i_r, tempASP_i_c: r_vector;
	variable disk_insert,no_insert: bit := '0';
	variable empty_cell: integer range 0 to 4 := 0;
	variable temp_ASP_lrow: integer range 0 to 7 := 0;
	variable temp_ASP_dr: bit_vector(0 to 7);
	variable flag: std_logic_vector(0 to 1);
	variable inserted: bit;
	variable k: integer range 0 to 8;
	variable row: integer range 0 to 5;
	variable column: integer range 0 to 6;

	
	BEGIN
		column :=0;
		row :=0;
		inserted := '0';
		empty_cell := 0;
		disk_insert := '0';
		no_insert := '0';
		r0:="000";
		c0:="000";
		c1:="000";
		r1:="000";
		
		
		--find empty cell
		if (control = '0') then 

		elsif (clk'EVENT AND clk='1') then
			if (rst = '1') then
				flag := "00";
				readwrite <= '1';
			elsif(flag = "01") then
				temp_GRA(0) := gra_in_row_0;
				temp_GRA(1) := gra_in_row_1;
				temp_GRA(2) := gra_in_row_2;
				temp_GRA(3) := gra_in_row_3;
				temp_GRA(4) := gra_in_row_4;
				temp_GRA(5) := gra_in_row_5;
				tempASP_i_r := ASP_i_r;
				tempASP_i_c := ASP_i_c;
				for i in 0 to 3 loop
					if(tempASP_i_r(i) /= "111") then
						empty_cell:= empty_cell + 1;
					end if;
				end loop;		
			
				---horizontal 
				if horizont = '1' then
					r0:=tempASP_i_r(0);
					r_n0 := to_integer(unsigned(r0));
					c0:=tempASP_i_c(0);
					c_n0 := to_integer(unsigned(c0-"001"));
			
					r1 := tempASP_i_r(empty_cell-1);
					r_n1 := to_integer(unsigned(r1));
					c1	:=	tempASP_i_c(empty_cell-1);
					c_n1 := to_integer(unsigned(c1+"001"));
			
					if ((c0 /= "000") and (temp_gra(r_n0)(c_n0) = "00")) then
						tempASP_i_r(3):=ASP_i_r(2);
						tempASP_i_r(2):=ASP_i_r(1);
						tempASP_i_r(1):=ASP_i_r(0);

						tempASP_i_c(3):=ASP_i_c(2);
						tempASP_i_c(2):=ASP_i_c(1);
						tempASP_i_c(1):=ASP_i_c(0);
		
						tempASP_i_r(0):=r0;
						tempASP_i_c(0):=c0-"001";
					
						temp_gra(r_n0)(c_n0):="01";
						row_inp_o <= r_n0;
						col_inp_o <= c_n0;
						disk_insert:='1';
					

					elsif((c1 /= "110") and (disk_insert='0')) then 
						if(temp_gra(r_n1)(c_n1) = "00") then
							tempASP_i_r(empty_cell):=r1;
							tempASP_i_c(empty_cell):=c1+"001";
							
							temp_gra(r_n1)(c_n1):="01";
							row_inp_o <= r_n1;
							col_inp_o <= c_n1;
							disk_insert:='1';
						end if;

					end if;
				end if;
			
				---verticle
				if vertic = '1' then
					r0:=tempASP_i_r(0);
					r_n0 := to_integer(unsigned(r0-"001"));
					c0:=tempASP_i_c(0);
					c_n0 := to_integer(unsigned(c0));
		
					r1 := tempASP_i_r(empty_cell-1);
					r_n1 := to_integer(unsigned(r1+"001"));
					c1	:=	tempASP_i_c(empty_cell-1);
					c_n1 := to_integer(unsigned(c1));
		
					if ((r0 /= "000") and (temp_gra(r_n0)(c_n0) = "00")) then
						tempASP_i_r(3):=ASP_i_r(2);
						tempASP_i_r(2):=ASP_i_r(1);
						tempASP_i_r(1):=ASP_i_r(0);
		
						tempASP_i_c(3):=ASP_i_c(2);
						tempASP_i_c(2):=ASP_i_c(1);
						tempASP_i_c(1):=ASP_i_c(0);
			
						tempASP_i_r(0):=r0-"001";
		
						tempASP_i_c(0):=c0;
					
						temp_gra(r_n0)(c_n0):="01";
						row_inp_o <= r_n0;
						col_inp_o <= c_n0;
						disk_insert:='1';
					

					elsif((r1 /= "101") and (disk_insert='0')) then 
						if(temp_gra(r_n1)(c_n1) = "00") then
							tempASP_i_r(empty_cell):=r1+"001";
							tempASP_i_c(empty_cell):=c1;
						
							temp_gra(r_n1)(c_n1):="01";
							row_inp_o <= r_n1;
							col_inp_o <= c_n1;
							disk_insert:='1';

						end if;
					end if;
				end if;
			
				---l-r diagonal
				if l_r_diag = '1' then
					r0:=tempASP_i_r(0);
					r_n0 := to_integer(unsigned(r0-"001"));
					c0:=tempASP_i_c(0);
					c_n0 := to_integer(unsigned(c0+"001"));
		
					r1 := tempASP_i_r(empty_cell-1);
					r_n1 := to_integer(unsigned(r1+"001"));
					c1	:=	tempASP_i_c(empty_cell-1);
					c_n1 := to_integer(unsigned(c1-"001"));
		
					if ((c0 /= "110") and (r0 /= "000") and (temp_gra(r_n0)(c_n0) = "00")) then
						tempASP_i_r(3):=ASP_i_r(2);
						tempASP_i_r(2):=ASP_i_r(1);
						tempASP_i_r(1):=ASP_i_r(0);
		
						tempASP_i_c(3):=ASP_i_c(2);
						tempASP_i_c(2):=ASP_i_c(1);
						tempASP_i_c(1):=ASP_i_c(0);
		
						tempASP_i_r(0):=r0-"001";

						tempASP_i_c(0):=c0+"001";
					
						temp_gra(r_n0)(c_n0):="01";
						row_inp_o <= r_n0;
						col_inp_o <= c_n0;
						disk_insert:='1';
					

					elsif((c1 /= "000") and (r1 /= "101") and (disk_insert='0')) then 
						if(temp_gra(r_n1)(c_n1) = "00") then
							tempASP_i_r(empty_cell):=r1+"001";
							tempASP_i_c(empty_cell):=c1-"001";
							
							temp_gra(r_n1)(c_n1):="01";
							disk_insert:='1';
							row_inp_o <= r_n1;
							col_inp_o <= c_n1;
						end if;
					end if;
				end if;
			
				---r-l diagnol
				if r_l_diag = '1' then
					r0:=tempASP_i_r(0);
					r_n0 := to_integer(unsigned(r0-"001"));
					c0:=tempASP_i_c(0);
					c_n0 := to_integer(unsigned(c0-"001"));
		
					r1 := tempASP_i_r(empty_cell-1);
					r_n1 := to_integer(unsigned(r1+"001"));
					c1	:=	tempASP_i_c(empty_cell-1);
					c_n1 := to_integer(unsigned(c1+"001"));
		
					if ((c0 /= "000") and (r0 /= "000") and (temp_gra(r_n0)(c_n0) = "00")) then
						tempASP_i_r(3):=ASP_i_r(2);
						tempASP_i_r(2):=ASP_i_r(1);
						tempASP_i_r(1):=ASP_i_r(0);
		
						tempASP_i_c(3):=ASP_i_c(2);
						tempASP_i_c(2):=ASP_i_c(1);
						tempASP_i_c(1):=ASP_i_c(0);
		
						tempASP_i_r(0):=r0-"001";

						tempASP_i_c(0):=c0-"001";
					
						temp_gra(r_n0)(c_n0):="01";
						row_inp_o <= r_n0;
						col_inp_o <= c_n0;
						disk_insert:='1';
					

					elsif((c1 /= "110") and (r1 /= "101") and (disk_insert='0')) then 
						if(temp_gra(r_n1)(c_n1) = "00") then
							tempASP_i_r(empty_cell):=r1+"001";
							tempASP_i_c(empty_cell):=c1+"001";
						
							temp_gra(r_n1)(c_n1):="01";
						
							disk_insert:='1';
							row_inp_o <= r_n1;
							col_inp_o <= c_n1;
						end if;
					end if;
				end if;
					
				if one_insert = '1' then
					r0:=tempASP_i_r(0);
					c0:=tempASP_i_c(0);
					disk_insert := '1';
					if (c0 /= "000" and temp_gra(to_integer(unsigned(r0)))(to_integer(unsigned(c0-"001"))) = "00") then
						tempASP_i_r(1):=ASP_i_r(0);
						tempASP_i_c(1):=ASP_i_c(0);
						tempASP_i_r(0):=r0;
						tempASP_i_c(0):=c0-"001";
						row_inp_o <= to_integer(unsigned(r0));
						col_inp_o <= to_integer(unsigned(c0-"001"));
						temp_gra(to_integer(unsigned(r0)))(to_integer(unsigned(c0-"001"))):="01";
					elsif (c0 /= "110" and temp_gra(to_integer(unsigned(r0)))(to_integer(unsigned(c0+"001"))) = "00") then
						tempASP_i_r(1):=r0;
						tempASP_i_c(1):=c0+"001";
						row_inp_o <= to_integer(unsigned(r0));
						col_inp_o <= to_integer(unsigned(c0+"001"));
						temp_gra(to_integer(unsigned(r0)))(to_integer(unsigned(c0-"001"))):="01";
					elsif (r0 /= "000" and temp_gra(to_integer(unsigned(r0-"001")))(to_integer(unsigned(c0))) = "00") then
						tempASP_i_r(1):=ASP_i_r(0);
						tempASP_i_c(1):=ASP_i_c(0);
						tempASP_i_r(0):=r0-"001";
						tempASP_i_c(0):=c0;
						row_inp_o <= to_integer(unsigned(r0-"001"));
						col_inp_o <= to_integer(unsigned(c0));
						temp_gra(to_integer(unsigned(r0+"001")))(to_integer(unsigned(c0))):="01";
					elsif (r0 /= "101" and temp_gra(to_integer(unsigned(r0+"001")))(to_integer(unsigned(c0))) = "00") then
						tempASP_i_r(1):=r0+"001";
						tempASP_i_c(1):=c0;
						row_inp_o <= to_integer(unsigned(r0+"001"));
						col_inp_o <= to_integer(unsigned(c0));
						temp_gra(to_integer(unsigned(r0)))(to_integer(unsigned(c0-"001"))):="01";
					elsif (r0 /= "000" and c0 /= "110" and temp_gra(to_integer(unsigned(r0-"001")))(to_integer(unsigned(c0+"001"))) = "00") then
						tempASP_i_r(1):=ASP_i_r(0);
						tempASP_i_c(1):=ASP_i_c(0);
						tempASP_i_r(0):=r0-"001";
						tempASP_i_c(0):=c0+"001";
						row_inp_o <= to_integer(unsigned(r0-"001"));
						col_inp_o <= to_integer(unsigned(c0+"001"));
						temp_gra(to_integer(unsigned(r0-"001")))(to_integer(unsigned(c0+"001"))):="01";
					elsif (r0 /= "101" and c0 /= "000" and temp_gra(to_integer(unsigned(r0+"001")))(to_integer(unsigned(c0-"001"))) = "00") then
						tempASP_i_r(1):=r0+"001";
						tempASP_i_c(1):=c0-"001";
						row_inp_o <= to_integer(unsigned(r0+"001"));
						col_inp_o <= to_integer(unsigned(c0-"001"));
						temp_gra(to_integer(unsigned(r0+"001")))(to_integer(unsigned(c0-"001"))):="01";
					elsif (r0 /= "000" and c0 /= "000" and temp_gra(to_integer(unsigned(r0-"001")))(to_integer(unsigned(c0-"001"))) = "00") then
						tempASP_i_r(1):=ASP_i_r(0);
						tempASP_i_c(1):=ASP_i_c(0);
						tempASP_i_r(0):=r0-"001";
						tempASP_i_c(0):=c0-"001";
						row_inp_o <= to_integer(unsigned(r0-"001"));
						col_inp_o <= to_integer(unsigned(c0-"001"));
						temp_gra(to_integer(unsigned(r0-"001")))(to_integer(unsigned(c0-"001"))):="01";
					elsif (r0 /= "101" and c0 /= "110" and temp_gra(to_integer(unsigned(r0+"001")))(to_integer(unsigned(c0+"001"))) = "00") then
						tempASP_i_r(1):=r0+"001";
						tempASP_i_c(1):=c0+"001";
						row_inp_o <= to_integer(unsigned(r0+"001"));
						col_inp_o <= to_integer(unsigned(c0+"001"));
						temp_gra(to_integer(unsigned(r0+"001")))(to_integer(unsigned(c0+"001"))):="01";
					else
						disk_insert := '0';
					end if;
				end if;
				--outputs		
				disk_ins <= disk_insert;
				no_insert := not disk_insert;
				no_ins <= not disk_insert;
				temp_ASP_lrow := to_integer(unsigned(ASP_lrow));
				temp_ASP_dr := ASP_dr_i;
				if(no_insert = '1') then
					if (horizont = '1' or vertic = '1' or l_r_diag = '1' or one_insert = '1' or r_l_diag = '1') then
						case temp_ASP_lrow is
							when 0 => temp_ASP_dr(0) := '1';
							when 1 => temp_ASP_dr(1) := '1';
							when 2 => temp_ASP_dr(2) := '1';
							when 3 => temp_ASP_dr(3) := '1';
							when 4 => temp_ASP_dr(4) := '1';
							when 5 => temp_ASP_dr(5) := '1';
							when 6 => temp_ASP_dr(6) := '1';
							when others => temp_ASP_dr(7) := '1';
						end case;
					end if;
					ASP_dr <= temp_ASP_dr;
					
					for i in 0 to 5 loop
						for j in 0 to 6 loop
							if (temp_GRA(i)(j) = "00" and inserted = '0') then

								inserted := '1';
								column := j;
								row := i;
							end if;	
						end loop;
					end loop;

					k := 0;
					while (k /= 8 and ASP_empty(k) = '0') loop
						k := k+1;
					end loop;
					row_inp_o <= row;
					col_inp_o <= column;
					case k is
						when 0 => 
							asp_reg_id <= 0;
							no_reg <= '0';
							readwrite <= '0';
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";		
						when 1 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 1;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 2 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 2;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 3 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 3;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 4 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 4;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 5 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 5;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 6 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 6;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 7 => 
							no_reg <= '0';
							readwrite <= '0';
							asp_reg_id <= 7;
							gra_out_cell <= "01";
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
						when 8 =>
							no_reg <= '1';
							readwrite <= '1';
							gra_out_cell <= temp_gra(to_integer(unsigned(r0)))(to_integer(unsigned(c0)));
							ASP_o_r(0) <= std_logic_vector(to_unsigned(row, 3));
							ASP_o_r(1) <= "111";
							ASP_o_r(2) <= "111";
							ASP_o_r(3) <= "111";		
							ASP_o_c(0) <= std_logic_vector(to_unsigned(column, 3));
							ASP_o_c(1) <= "111";
							ASP_o_c(2) <= "111";
							ASP_o_c(3) <= "111";
					end case;
					
				else
					case temp_ASP_lrow is
						when 0 =>
							asp_reg_id <= 0;
						when 1 =>
							asp_reg_id <= 1;
						when 2 =>
							asp_reg_id <= 2;
						when 3 =>
							asp_reg_id <= 3;
						when 4 =>
							asp_reg_id <= 4;
						when 5 =>
							asp_reg_id <= 5;			
						when 6 =>
							asp_reg_id <= 6;
						when 7 =>
							asp_reg_id <= 7;
					end case;
					ASP_dr <= ASP_dr_i;
					ASP_o_r <= tempASP_i_r;
					ASP_o_c <= tempASP_i_c;
					gra_out_cell <= "01";
					no_reg <= '0';
					readwrite <= '0';
				end if;
				flag := "10";
			elsif(flag = "00") then
				flag := "01";
				readwrite <= '1';
			elsif(flag = "10") then
				flag := "00";
				readwrite <= '1';
			end if;
		end if;
	end process;
end a;
