#include "I2Cdev.h"
#include "MPU6050_6Axis_MotionApps20.h"
#include "Wire.h"


////////////////////////////////////////////
// PIN Assignments //
////////////////////////////////////////////

#define DAC_PIN DAC0
#define A1_PIN A1

#define pin_IMU_interrupt 2
#define pin_IMU_SDA 20
#define pin_IMU_SCL 21


////////////////////////////////////////////
// Variables for sampling //
////////////////////////////////////////////
float current_time;
float previous_time;
float time0;

const float t_cycle = 100; // 1ms
const int t_exp = 10000000; //(10sec)
const int nb_cycles = t_exp/t_cycle;
const int t_start = 1000000; 
const int t_end = 11000000;



////////////////////////////////////////////
// Variables for Theta Calculations //
////////////////////////////////////////////

float theta_time = 0; // Time of Theta calculation
float cycle_time = 0; // Time since last Theta calculation

float theta= 0; // Pendulum angle
float theta_prev = 0; //Previous pendulum angle
float dTheta = 0; // Pendulum Angular velocity  
float dTheta_prev = 0; // Previous angular velocity of pendulum

////////////////////////////////////////////
// Controller Variables //
////////////////////////////////////////////
float dac_value = 0;
float command = 0;
float command_prev = 0;

//float const K1 = 0.6583;
//float const K2 = 0.2785;
//float const K3 = 0.0003;

/*
// With older coefficient between position and speed
float const K1= 0.9812;
float const K2= 0.1142;
float const K3= 0.0011;
*/

// new coeff: works very well also!
float const K1= 0.8912;
float const K2= 0.1142;
float const K3= 0.0011;

/*
//New model R = 1e7
float const K1 = 0.6804;
float const K2 = 0.0931;
float const K3 = 0.0031;
*/
/*
//New model R = 1e7 T = 6
float const K1 = 0.5736;
float const K2 = 0.0789;
float const K3 = 0.0031;
*/

/*
//New model R = 1e7 T = 6 I = 0.011, bp = 0.03
float const K1 = 0.6538;
float const K2 = 0.0763;
float const K3 = 0.0031;
*/

const int NB_DATA=5000;
float tab_error_out[NB_DATA];
float tab_speedref_motor[NB_DATA];
float ref_speed=0;

/*
float const a = -178.9;
float const b = 352.4;
float const c = -173.6;
float const d = -1.991;
float const e = 0.991;
*/

float const a = -1040;
float const b = 17810;
float const c = -7621;
float const d = -0.1994;
float const e = -0.02968;



////////////////////////////////////////////
// Motor Speed Variables //
////////////////////////////////////////////

float current_speed = 0;
float filtered_speed = 0;
float previous_speed = 0;
float smoothing = 0.99;

////////////////////////////////////////////
// SETUP PROCEDURE //
//////////////////////////////////////////// 

void setup() {
Serial.begin(115200);

pinMode(DAC_PIN,OUTPUT);
pinMode(A1_PIN,INPUT);

pinMode(pin_IMU_interrupt, INPUT);

IMU_setup();
dac_value = 0*(4095/4.66)+2047.5;
dac_value = constrain(dac_value,0,4095);
analogWrite(DAC_PIN,dac_value);
}