#include "digcomp.h"

int analogPin = A0; 
                    
int val = 0; 
float voltage = 0.0;
float ECG_V   = 0.0;
int moving_avg = 2;

// filtering
float hp_out_sig, lp_out_sig;
float b_lp[2] = {0, 0.4665};
float a_lp[2] = {1, -0.5335};
float lp_in[2];
float lp_out[2];

// not able to remove DC offset
float b_hp[2] = {1, -1.0000};
float a_hp[2] = {1, -0};
float hp_in[2];
float hp_out[2];

dig_comp lpfil(b_lp, a_lp, lp_in, lp_out, 2, 2);
dig_comp hpfil(b_hp, a_hp, hp_in, hp_out, 2, 2);

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
  hp_out_sig = hpfil.calc_out(ECG_V);

  Serial.println(lp_out_sig); 
 

  voltage = 0.0;
}
