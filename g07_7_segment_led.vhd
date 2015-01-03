--Antoine Bosselut

LIBRARY lpm;
Library ieee;
use lpm.lpm_components.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity g07_7_segment_led is
port ( 
	ascii_code : in std_logic_vector(6 downto 0);
	segments : out std_logic_vector(6 downto 0);
	clk: in std_logic);
end g07_7_segment_led;

Architecture a of g07_7_segment_led is
begin
crc_table : lpm_rom -- use the altera rom library macrocell
GENERIC MAP(
lpm_widthad => 7, -- sets the width of the ROM address bus
lpm_numwords => 128, -- sets the words stored in the ROM
lpm_outdata => "REGISTERED", -- register on the output
lpm_address_control => "REGISTERED", -- register on the input
lpm_file => "lcd_decoder_rom.mif", -- the ascii file containing the ROM data
lpm_width => 7) -- the width of the word stored in each ROM location
PORT MAP(address => ascii_code, q => segments, inclock => clk, outclock => clk);

end a;