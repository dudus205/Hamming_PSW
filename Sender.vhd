LIBRARY ieee ;
USE ieee.std_logic_1164.ALL ;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.numeric_std.ALL; 
ENTITY sender IS
PORT ( 
 input : IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
 reset : IN STD_LOGIC;
 data : OUT STD_ULOGIC;
 transmission_clock : OUT STD_LOGIC;
 clock : IN STD_LOGIC ;
 sent : OUT STD_LOGIC );
END sender ;

ARCHITECTURE behaviour OF sender IS
SHARED VARIABLE hamout : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
BEGIN
	
	transmission_clock <= clock;
	
	Hamming_process : process IS
	VARIABLE p0, p1, p3, p7 : STD_LOGIC; --check bits
	BEGIN
		WAIT UNTIL rising_edge(reset);
		
		p0 := ((input(0) XOR input(1)) XOR input(3)) XOR input(6);
		p1 := (((input(0) XOR input(2)) XOR input(3)) XOR input(5)) XOR input(6);
		p3 := ((input(1) XOR input(2)) XOR input(3)) XOR input(7);
		p7 := ((input(4) XOR input(5)) XOR input(6)) XOR input(7);
		
		--connect up outputs
		hamout(0) := p0;
		hamout(1) := p1;
		hamout(2) := (input(0));
		hamout(3) := (p3);
		hamout(6 DOWNTO 4) := (input(3 DOWNTO 1));
		hamout(7) := (p7);
		hamout(11 DOWNTO 8) := input(7 DOWNTO 4);	
		
	END process Hamming_process;
	
	send_process : process IS
	VARIABLE counter : STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	CONSTANT zero : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	BEGIN
		WAIT UNTIL rising_edge(clock);
		IF reset='1' THEN
			counter := zero;
			--data <= 'Z';
		ELSE
		counter := (counter+1);
		IF (clock = '1') THEN
			IF (counter = "1101") THEN
				counter := zero;
				--data <= 'Z';
				sent <= '1';
			ELSE
				data <= hamout(conv_integer(counter) - 1);
				sent <= '0';
			END IF;
		ELSE
			--data <= 'Z';
		END IF;
		END IF;
	END process send_process;

	
END behaviour ;