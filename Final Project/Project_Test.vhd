LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY TLC_TEST IS
END ENTITY;


ARCHITECTURE TLC_Arch OF TLC_TEST IS
  SIGNAL CLK,RST                     : STD_LOGIC;
  SIGNAL P_B_0,P_B_01                : STD_LOGIC;
  SIGNAL SENSOR_IN_P0,SENSOR_IN_P1   : STD_LOGIC;
  SIGNAL SENSOR_OUT_P0,SENSOR_OUT_P1 : STD_LOGIC;
  SIGNAL Traffic_Lights              : STD_LOGIC_VECTOR(11 DOWNTO 0);

  
BEGIN
  
DUT: ENTITY WORK.TLC PORT MAP(
  CLK => CLK,
  RST => RST,
  P_B_0      => P_B_0,
  P_B_1      => P_B_1,
  Sensor_In_0   => Sensor_In_0,
  Sensor_In_1   => Sensor_In_1,
  Sensor_Out_0  => Sensor_Out_0,
  Sensor_Out_1  => Sensor_Out_1,
  Traffic_Lights => Traffic_Lights
  );

CLK_TIME: PROCESS
BEGIN
CLK <= '0'; WAIT FOR 10 NS;
CLK <= '1'; WAIT FOR 10 NS;
END PROCESS;

STIMULIS : PROCESS
BEGIN
 REPORT("Starting simulation");
 
 RST <= '1';
 P_B_0 <= '0';
 P_B_1 <= '0';
 Sensor_In_0 <= '0';
 Sensor_In_1 <= '0';
 wait for 20 ns;
 
 RST <= '0'; 
 P_B_0 <= '0';
 P_B_1 <= '1';
 Sensor_In_0 <= '1';
 Sensor_In_1 <= '1';
 wait for 300 ns;
 
 RST <= '0';
 P_B_0 <= '1';
 P_B_1 <= '0';
 Sensor_In_0 <= '1';
 Sensor_In_1 <= '1';
 wait for 400 ns;
 
 RST <= '0';
 P_B_0 <= '0';
 P_B_1 <= '0';
 Sensor_In_0 <= '0';
 Sensor_In_1 <= '0';
 wait for 500 ns;
 
 REPORT("Ending simulation");
END PROCESS;
   
END ARCHITECTURE;
