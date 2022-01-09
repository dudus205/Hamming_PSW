LIBRARY ieee ;
USE ieee.std_logic_1164.ALL ;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.numeric_std.ALL; 
ENTITY interupter IS
PORT ( 
 dataIn : IN STD_LOGIC;
 reverseBitIndex : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 reset : IN STD_LOGIC;
 clock : IN STD_LOGIC ;
 dataOut : OUT STD_LOGIC);
END interupter ;

ARCHITECTURE behaviour OF interupter IS
SHARED VARIABLE act : STD_LOGIC;
BEGIN

	dataOut <= dataIn XOR act;
	interruptProcess : process IS
	VARIABLE counter : STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	CONSTANT zero : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	BEGIN
		WAIT UNTIL rising_edge(clock);
		
		IF (reset = '1') THEN
			counter := zero;
		ELSE
			
			IF (counter = "1100") THEN
				counter := zero;
			ELSE 
				counter := counter + '1';
			END IF;
			IF (counter = (reverseBitIndex + 1)) THEN
				act := '1';
			ELSE
				act := '0';
			END IF;
		END IF;
		
	END process interruptProcess;
END behaviour;
