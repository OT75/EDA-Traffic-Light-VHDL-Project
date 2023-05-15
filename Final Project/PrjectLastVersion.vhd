LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MAIN IS
     PORT(
         CLK,RST                     : IN STD_LOGIC;
         BUTTON_P0,BUTTON_P1         : IN STD_LOGIC;
         SENSOR_IN_P0,SENSOR_IN_P1   : IN STD_LOGIC;
         SENSOR_OUT_P0,SENSOR_OUT_P1 : OUT STD_LOGIC;
         Traffic_Lights              : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
         );
END MAIN;


ARCHITECTURE BEHAVE of MAIN is
TYPE STATES IS ( S0_L0G_P0R_L1R_P1G, S1_L0Y_P0R_L1R_P1Y, S2_L0R_P0G_L1G_P1R, S3_L0R_P0Y_L1Y_P1R, SAFETY_ALL_RED) ;
SIGNAL STATE   : STATES ;
SIGNAL TIMER   : STD_LOGIC_VECTOR (2 DOWNTO 0) ;

CONSTANT wsec    : std_logic_vector (2 DOWNTO 0) := "110";
CONSTANT tsec    : std_logic_vector (2 DOWNTO 0) := "010";
CONSTANT safety  : std_logic_vector (2 DOWNTO 0) := "011";


BEGIN
    PROCESS (CLK,RST)
    BEGIN
    
    IF RST = '1' THEN
    STATE <= SAFETY_ALL_RED;
    TIMER <= "000";
  
    ELSIF CLK' event AND CLK = '1' THEN
    
    CASE (STATE) IS
      
    WHEN SAFETY_ALL_RED => 
    IF BUTTON_P0 = '1' THEN
    STATE <= S1_L0Y_P0R_L1R_P1Y;
    TIMER <= "000";
    ELSIF BUTTON_P1 = '1' THEN
    STATE <= S0_L0G_P0R_L1R_P1G;
    TIMER <= "000";
    ELSE
    STATE <= S0_L0G_P0R_L1R_P1G;
    END IF;
    
    WHEN S0_L0G_P0R_L1R_P1G =>
    IF TIMER < wsec THEN
    STATE <= S0_L0G_P0R_L1R_P1G;
    TIMER <= TIMER + 1;
    ELSE
    STATE <= S1_L0Y_P0R_L1R_P1Y;
    TIMER <= "000";
    END IF;

    when S1_L0Y_P0R_L1R_P1Y =>
    IF TIMER < tsec then
    STATE <= S1_L0Y_P0R_L1R_P1Y;
    TIMER <= TIMER + 1;
    ELSE
    STATE <= S2_L0R_P0G_L1G_P1R;
    TIMER <= "000";
    END IF;
    
    when S2_L0R_P0G_L1G_P1R =>
    IF TIMER < wsec then
    STATE <= S2_L0R_P0G_L1G_P1R;
    TIMER <= TIMER + 1;
    ELSE
    STATE <= S3_L0R_P0Y_L1Y_P1R;
    TIMER <= "000";
    END IF;
    
    WHEN S3_L0R_P0Y_L1Y_P1R =>
    IF TIMER < tsec THEN
    STATE <= S3_L0R_P0Y_L1Y_P1R;
    TIMER <= TIMER + 1;
    ELSE
    STATE <=SAFETY_ALL_RED;
    TIMER <= "000";
    END IF;
    
    
    
    WHEN OTHERS =>
    STATE <= S0_L0G_P0R_L1R_P1G;
    
    END CASE;
    END IF;
    END PROCESS;
    
    SENSOR_OUTPUT: PROCESS (SENSOR_IN_P0,SENSOR_IN_P1,STATE)
    BEGIN
        IF   (SENSOR_IN_P0 = '1' AND (STATE = S0_L0G_P0R_L1R_P1G OR STATE = S1_L0Y_P0R_L1R_P1Y)) 
        THEN SENSOR_OUT_P0 <= '1';
        ELSE SENSOR_OUT_P0 <= '0';
        END IF;
        
        IF   (SENSOR_IN_P1 = '1' AND (STATE = S2_L0R_P0G_L1G_P1R OR STATE = S3_L0R_P0Y_L1Y_P1R)) 
        THEN SENSOR_OUT_P1 <= '1';
        ELSE SENSOR_OUT_P1 <= '0';
        END IF;
    END PROCESS;

    STATE_OUTPUT: PROCESS (STATE)
    BEGIN
        CASE STATE IS                                                        -- lane 1 _ people 1 _ lane 2 _ people 2
            WHEN S0_L0G_P0R_L1R_P1G => Traffic_Lights <= b"001_100_100_001"; -- green  _ red      _ red    _ green
            WHEN S1_L0Y_P0R_L1R_P1Y => Traffic_Lights <= b"010_100_100_010"; -- yellow _ red      _ red    _ yellow
            WHEN S2_L0R_P0G_L1G_P1R => Traffic_Lights <= b"100_001_001_100"; -- red    _ green    _ green  _ red
            WHEN S3_L0R_P0Y_L1Y_P1R => Traffic_Lights <= b"100_010_010_100"; -- red    _ yellow   _ yellow _ red
            
            WHEN SAFETY_ALL_RED     => Traffic_Lights <= b"100_100_100_100"; -- red    _ red      _ red    _ red (safety case)
            
            WHEN OTHERS => Traffic_Lights <= b"001_100_100_001";
        END CASE;
    END PROCESS;

END BEHAVE;
