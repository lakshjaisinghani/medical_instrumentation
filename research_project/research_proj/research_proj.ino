#include "digcomp.h"

// arduino def
int analogPin = A0; 

// read variables
int val = 0; 
float voltage = 0.0;
float ECG_V   = 0.0;
int moving_avg = 100;

// filtering
float lp_out_sig;
float b_lp[2] = {0, 0.4665};
float a_lp[2] = {1, -0.5335};
float lp_in[2];
float lp_out[2];

float hp_out_sig;
float b_hp[2] = {0, -1.0000};
float a_hp[2] = {1, -0.0592};
float hp_in[2];
float hp_out[2];

dig_comp lpfil(b_lp, a_lp, lp_in, lp_out, 2, 2);
dig_comp hpfil(b_hp, a_hp, hp_in, hp_out, 2, 2);

// find maxima
float prev_val = 0.0;
float curr_val = 0.0;
float next_val = 0.0; 

void setup() {
  Serial.begin(9600);           //  setup serial
}

void loop() {
  val = analogRead(analogPin);  // read the input pin

  for (int i = 0; i < moving_avg; i++)
  {
    voltage += val * (5.0 / 1023.0);
  }

  ECG_V = voltage/moving_avg;

  lp_out_sig = lpfil.calc_out(ECG_V);
  
  Serial.println(lp_out_sig); 
 
  voltage = 0.0;
}
