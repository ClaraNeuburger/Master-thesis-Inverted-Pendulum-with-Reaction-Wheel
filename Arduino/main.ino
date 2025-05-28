////////////////////////////////////////////
// Main Loop //
////////////////////////////////////////////
void loop() {
while(micros()<t_start){
  dac_value = 0*(4095/4.66)+2047.5;
  dac_value = constrain(dac_value,0,4095);
  analogWrite(DAC_PIN,dac_value);
  getTheta();
}
while(micros()>=t_start && micros()<t_end){
  time0=micros();
  previous_time = time0;

  for(int j=0; j<nb_cycles;j++){
    current_time = micros();

    // Read Motor Speed
    getMotorSpeeds();

    // Calculate Theta and dTheta
    getTheta();

    // Let controller calculate set values for motors
    getRegulationLQR();

    // Set desired motor values
    setMotorSpeeds();

    // Print to Serial output for plotting
    printSerial();
    previous_time=current_time;
    while(micros()-time0 <(j+1)*t_cycle) {}
    
  }

  while(micros()>=t_end){
    setMotorSpeedsNull();
  }
  
}

}


////////////////////////////////////////////
// Calculate Motor Speeds in rad/s //
////////////////////////////////////////////
void getMotorSpeeds() {
  int raw_bit_value = analogRead(A1_PIN);
  current_speed = raw_bit_value*2.55 - 5240;
}


////////////////////////////////////////////
// Theta Calculations //
////////////////////////////////////////////
void getTheta(){
getIMUValues();
// Calculations for theta and dTheta
cycle_time = (float)(micros() - theta_time);
theta_time = (float) micros();
theta_prev = theta;
dTheta_prev = dTheta;
// Filter theta value
theta = (float) (1-0.7)*angle + 0.7*theta_prev;
// Find dTheta and apply filter
dTheta = (float) (theta - theta_prev)/cycle_time * 1000000.;
dTheta = (float) (1-0.7)*dTheta + 0.7*dTheta_prev;


}


////////////////////////////////////////////
// Controller Calculations for LQR //
// current control of the ESCON !  //
////////////////////////////////////////////
void getRegulationLQR(){
  if(theta < 11 && theta>-11){
    command = -(K1*angle + K2*dTheta + K3*(current_speed));
  }
  else {
    command = 0;
  }

// Security 
  if(command>2.33){
    command = 2.33;
  }
  if(command<-2.33){
    command = -2.33;
  }

}

////////////////////////////////////////////
// Set Motor output to desired value //
////////////////////////////////////////////

void setMotorSpeeds(){
if(command != command_prev){

    dac_value = command*(4095/4.66)+2047.5;
    dac_value = constrain(dac_value,0,4095);
    analogWrite(DAC_PIN,dac_value);

}
command_prev = command;
}


////////////////////////////////////////////
// Set Motor output to 0 (turn off motor) //
////////////////////////////////////////////

void setMotorSpeedsNull(){
    dac_value = 0*(4095/4.66)+2047.5;
    dac_value = constrain(dac_value,0,4095);
    analogWrite(DAC_PIN,dac_value);

}

////////////////////////////////////////////
// Serial Print //
////////////////////////////////////////////
void printSerial(){
Serial.print((current_time-t_start)/1000000);
Serial.print("\t");
Serial.print(angle);
Serial.print("\t");
Serial.print(current_speed);
Serial.print("\t");
Serial.print(command);
Serial.print("\t");
Serial.println(dTheta);
}