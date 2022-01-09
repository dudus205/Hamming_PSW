LIBRARY ieee ;
USE ieee.std_logic_1164.ALL ;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.numeric_std.ALL; 
ENTITY receiver IS
PORT ( 
 output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) ;
 ready : OUT STD_LOGIC;
 data : IN STD_LOGIC;
 transmission_clock : IN STD_LOGIC;
 reset : IN STD_LOGIC);
END receiver ;



ARCHITECTURE behaviour OF receiver IS
BEGIN
	
	receiving_process : process IS
	VARIABLE counter : STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	CONSTANT zero : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	VARIABLE hamin : STD_LOGIC_VECTOR(11 DOWNTO 0);
	VARIABLE pairity : STD_LOGIC_VECTOR(3 DOWNTO 0);
	BEGIN
		WAIT UNTIL falling_edge(transmission_clock);
		IF (reset = '1') THEN
			counter := "0000";
		ELSE
			counter := counter + '1';
		
			IF (counter = "1101") THEN
				counter := zero;
				ready <= '1';
				--odkodowanie i na output
				
				for i in 0 to (hamin'length -1) loop
					IF (hamin(i) = '1') THEN
						pairity := pairity XOR (conv_std_logic_vector(i, 4) + 1);
					END IF;
					IF (i = 11 ) THEN
						IF(pairity /= zero) THEN
							hamin(conv_integer(pairity) -1) := hamin(conv_integer(pairity) -1) XOR '1';
						END IF;
						output(0) <= hamin(2);
						output(3 DOWNTO 1)<= hamin(6 DOWNTO 4);
						output(7 DOWNTO 4) <= hamin(11 DOWNTO 8);	
					END IF;
				end loop;
			ELSE
				hamin(conv_integer(counter) - 1) := data;
				ready <= '0';
				pairity := zero;
			END IF;
		END IF;
	END process receiving_process;

END behaviour ;