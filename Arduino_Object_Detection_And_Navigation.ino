#include <util/atomic.h>

#include <NewPing.h>


//NewPing Library and Documentation can be found at
//http://playground.arduino.cc/Code/NewPing

 
#define TRIGGER_PIN  28
#define ECHO_PIN1     52
#define ECHO_PIN2     50
#define ECHO_PIN3     48
#define ECHO_PIN4     46
#define ECHO_PIN5     42
#define ECHO_PIN6     43
#define ECHO_PIN7     40

#define MAX_DISTANCE 200

int u3, u2, u1, u5, u7, u6, u4, i1,i_left,i_right, crossroads_counter, forwardstate, oldval_L, oldval_R;

String output_val = String("Test");
 
NewPing sonar1(TRIGGER_PIN, ECHO_PIN1, MAX_DISTANCE);
NewPing sonar2(TRIGGER_PIN, ECHO_PIN2, MAX_DISTANCE);
NewPing sonar3(TRIGGER_PIN, ECHO_PIN3, MAX_DISTANCE);
NewPing sonar4(TRIGGER_PIN, ECHO_PIN4, MAX_DISTANCE);
NewPing sonar5(TRIGGER_PIN, ECHO_PIN5, MAX_DISTANCE);
NewPing sonar6(TRIGGER_PIN, ECHO_PIN6, MAX_DISTANCE);
NewPing sonar7(TRIGGER_PIN, ECHO_PIN7, MAX_DISTANCE);

// A class to compute the control signal
class SimplePID{
  private:
    float kp, kd, ki, umax; // Parameters
    float eprev, eintegral; // Storage

  public:
  // Constructor
  SimplePID() : kp(1), kd(0), ki(0), umax(255), eprev(0.0), eintegral(0.0){}

  // A function to set the parameters
  void setParams(float kpIn, float kdIn, float kiIn, float umaxIn){
    kp = kpIn; kd = kdIn; ki = kiIn; umax = umaxIn;
  }

  // A function to compute the control signal
  void evalu(int value, int target, float deltaT, int &pwr, int &dir){
    // error
    int e = target - value;
  
    // derivative
    float dedt = (e-eprev)/(deltaT);
  
    // integral
    eintegral = eintegral + e*deltaT;
  
    // control signal
    float u = kp*e + kd*dedt + ki*eintegral;
  
    // motor power
    pwr = (int) fabs(u);
    if( pwr > umax ){
      pwr = umax;
    }
  
    // motor direction
    dir = 1;
    if(u<0){
      dir = -1;
    }
  
    // store previous error
    eprev = e;
  }
  
};

// How many motors
#define NMOTORS 2

// Pins
const int enca[] = {2,19};
const int encb[] = {3,20};
const int pwm[] = {8,11};
const int in1[] = {9,32};
const int in2[] = {10,34};

// Globals
volatile int posi[] = {0,0};
float target[2] = {0,0};

// PID class instances
SimplePID pid[NMOTORS];

void setup() {
  Serial.begin(9600);

  for(int k = 0; k < NMOTORS; k++){
    pinMode(enca[k],INPUT);
    pinMode(encb[k],INPUT);
    pinMode(pwm[k],OUTPUT);
    pinMode(in1[k],OUTPUT);
    pinMode(in2[k],OUTPUT);

    pid[k].setParams(1,0.1,0,255);
  }
  
  attachInterrupt(digitalPinToInterrupt(enca[0]),readEncoder<0>,RISING);
  attachInterrupt(digitalPinToInterrupt(enca[1]),readEncoder<1>,RISING);
  
  Serial.println("target pos");
}

void sensor(){
  delay(30);
  u3 = sonar1.ping_cm();
  delay(30);
  u2 = sonar2.ping_cm();
  delay(30);
  u1 = sonar3.ping_cm();
  delay(30);
  u5 = sonar4.ping_cm();
  delay(30);
  u7 = sonar5.ping_cm();
  delay(30);
  u6 = sonar6.ping_cm();
  delay(30);
  u4 = sonar7.ping_cm();
  i1 = analogRead(A1);
  
  Serial.print(" U3: ");
  Serial.print(u3);
  Serial.print(" U2: ");
  Serial.print(u2);
  Serial.print(" U1: ");
  Serial.print(u1);
  Serial.print(" U5: ");
  Serial.print(u5);
  Serial.print(" U7: ");
  Serial.println(u7);
  Serial.print(" U6: ");
  Serial.println(u6);
  Serial.print(" U4: ");
  Serial.println(u4);
  Serial.print(" I1: ");
  Serial.println(i1);



}

void ir(){
  i1 = analogRead(A1);
  Serial.print(" I1: ");
  Serial.println(i1);

}

void loop() {

forwardstate = 0;




sensor();

  if (u1 > 12 and u2 > 7 and u3 > 7 and u5 > 2 and u7 > 2) { //Forward

  if (u5+u7 > 80 and u1 > 30 and u6 > 20 and (u7 > 20 and u5 > 20)){

    Serial.print("Crossroads");

    if (crossroads_counter == 0) {
            Serial.print("Crossroads_forward");
            target[0] = 140;
            target[1] = -140;
            control();
            delay(50);
            posi[0]=0;
            posi[1]=0;

      crossroads_counter = 1;
    }
    else if (i1 > 150){
        Serial.print("Crossroads Blindspot Check");
        target[0] = -100;
        target[1] = 100;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;

        target[0] = 150;
        target[1] = 150;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;
        delay(200);
        ir();
        i_left = i1;
        delay(200);


        target[0] = -150;
        target[1] = -150;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;

        target[0] = -150;
        target[1] = -150;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;
        delay(200);
        ir();
        i_right = i1;
        delay(200);

        target[0] = 150;
        target[1] = 150;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;

        if (i_right < i_left) {
          Serial.print("Right Clear");
          target[0] = -150;
          target[1] = -150;
          control();
          delay(50);
          posi[0]=0;
          posi[1]=0;
          

        }

        else if (i_right > i_left) {

          Serial.print("Left Clear");
          target[0] = 150;
          target[1] = 150;
          control();
          delay(50);
          posi[0]=0;
          posi[1]=0;


        }





     }
    else {
      Serial.print("Slow Forward In Crossroads");


      target[0] = 110;
      target[1] = -110;
      control();
      delay(50);
      posi[0]=0;
      posi[1]=0;




    }
  


    forwardstate = 1;

     
  }

  else{

  if (u5 - oldval_R > 20 and (u5 < 25 or u7 < 25) and (u5 > 7 or u7 > 7) and (u1+u6 > 60)){
  Serial.print("Right Blindspot Adjustment");
  target[0] = 90;
  target[1] = 90;
  control();
  delay(50);
  posi[0]=0;
  posi[1]=0;


  forwardstate = 1;

  crossroads_counter = 0;

  }


  else if (u7 - oldval_L > 20 and (u5 < 25 or u7 < 25) and (u5 > 7 or u7 > 7) and (u1+u6 > 80)){

  Serial.print("Left Blindspot Adjustment");

  target[0] = -110;
  target[1] = -110;
  control();
  delay(50);
  posi[0]=0;
  posi[1]=0;  

  forwardstate = 1;

  crossroads_counter = 0;

  }

    else if (u5 < 3) { // Left

    Serial.println("15 Degree Left");
    target[0] = 80;
    target[1] = 80;
    control();
    delay(50);
    posi[0]=0;
    posi[1]=0;
    forwardstate = 1;

    crossroads_counter = 0;

    }

    else if (u7 < 3) { // Right

    Serial.println("15 Degree Right");
    target[0] = -80;
    target[1] = -80;
    control();
    delay(50);
    posi[0]=0;
    posi[1]=0;
    forwardstate = 1;

    crossroads_counter = 0;

    }

    else {
    Serial.println("Forward");
    //Move forward by 10 cm

      target[0] = 160;
      target[1] = -160;
      control();
      delay(50);
      posi[0]=0;
      posi[1]=0;

      forwardstate = 1;

      crossroads_counter = 0;


    }
   }

   
  }  

  if (forwardstate == 0) {


    if (u1 < 14 and u2 < 14 and u3 < 14 and u5 < 14 and u7 < 14) {
        Serial.println("180 Degree CCW");
        target[0] = 174;
        target[1] = 174;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;
        target[0] = 174;
        target[1] = 174;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;
        target[0] = 174;
        target[1] = 174;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;

    }
    
  
    else if ((u2 < u3)) { //Left
        Serial.println("30 Degree Left");
        target[0] = 87;
        target[1] = 87;
        control();
        delay(50);
        posi[0]=0;
        posi[1]=0;
        

    }

    else if ((u2 >= u3)) { //Right

      Serial.println("30 Degree Right");
      //Turn 90 degrees to right
      target[0] = -87;
      target[1] = -87;
      control();
      delay(50);
      posi[0]=0;
      posi[1]=0;


    }

    crossroads_counter = 0;
  
  }

  Serial.println(forwardstate);
  oldval_R = u5;
  oldval_L = u7;

  Serial.println(oldval_R);
  Serial.println(oldval_L);


}


void control(){
  int pos_old = 1;
  long prevT = 0;
  float t = micros()/(1.0e6);
 

  while (true) {
      // set target position
  //int target[NMOTORS];
  //target[0] = 520*sin(prevT/1e6);
  //target[1] = 520*sin(prevT/1e6);
 

  

  // time difference
  long currT = micros();
  float deltaT = ((float) (currT - prevT))/( 1.0e6 );
  prevT = currT;

  /*/
  if (currT/1.0e6 <4){
    target[0] = 0;
    target[1] = 0;
  }
  else {
    target[0] = 400*4.9;
    target[1] = -400*4.9;
  }
  /*/


  // Read the position in an atomic block to avoid a potential misread
  int pos[NMOTORS];
  ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
    for(int k = 0; k < NMOTORS; k++){
      pos[k] = posi[k];
    }
  }
  
  // loop through the motors
  for(int k = 0; k < NMOTORS; k++){
    int pwr, dir;
    // evaluate the control signal
    pid[k].evalu(pos[k],target[k],deltaT,pwr,dir);
    // signal the motor
    setMotor(dir,pwr,pwm[k],in1[k],in2[k]);
  }


/*
  for(int k = 0; k < NMOTORS; k++){
    Serial.print(target[k]);
    Serial.print(" ");
    Serial.print(pos[k]);
    Serial.print(" ");
  }
  Serial.println();
*/

  if (currT/(1.0e6)> t + 0.8){
    break;
  }
  pos_old = pos[0];
}
}




void setMotor(int dir, int pwmVal, int pwm, int in1, int in2){
  analogWrite(pwm,pwmVal);
  if(dir == 1){
    digitalWrite(in1,HIGH);
    digitalWrite(in2,LOW);
  }
  else if(dir == -1){
    digitalWrite(in1,LOW);
    digitalWrite(in2,HIGH);
  }
  else{
    digitalWrite(in1,LOW);
    digitalWrite(in2,LOW);
  }  
}

template <int j>
void readEncoder(){
  int b = digitalRead(encb[j]);
  if(b > 0){
    posi[j]++;
  }
  else{
    posi[j]--;
  }
}
