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

#define LED 12

#define MAX_DISTANCE 200

#define digital_pin 7

int u3, u2, u1, u5, u7, u6, u4, i1, value, posi_counter_l, posi_counter_r;
 
NewPing sonar1(TRIGGER_PIN, ECHO_PIN1, MAX_DISTANCE);
NewPing sonar2(TRIGGER_PIN, ECHO_PIN2, MAX_DISTANCE);
NewPing sonar3(TRIGGER_PIN, ECHO_PIN3, MAX_DISTANCE);
NewPing sonar4(TRIGGER_PIN, ECHO_PIN4, MAX_DISTANCE);
NewPing sonar5(TRIGGER_PIN, ECHO_PIN5, MAX_DISTANCE);
NewPing sonar6(TRIGGER_PIN, ECHO_PIN6, MAX_DISTANCE);
NewPing sonar7(TRIGGER_PIN, ECHO_PIN7, MAX_DISTANCE);


#include <Servo.h> 
 
Servo sservo;  // create servo object for small servo motor
Servo lservo;  // create servo object for large servo motor 

bool blockDetect = true;   //variable to trigger closing of gripper --> only if block is detected
bool LZ = true;            //triggers when robot is in loading zone
bool ULZ = true;          //triggers when in unloading zone
int pos1 = 0;    // variable to store the servo position 
int pos2 = 75;
int pos3 = 150;

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
  Serial2.begin(9600);


  sservo.write(20); //initialize @ 20
  sservo.attach(7);  // attaches the servo on pin 9 on the arduino
  lservo.write(0); // operating range: 0 - 92, initialize @ 0
  lservo.attach(13);  // attach large servo to pin 5 on the arduino
  

  for(int k = 0; k < NMOTORS; k++){
    pinMode(enca[k],INPUT);
    pinMode(encb[k],INPUT);
    pinMode(pwm[k],OUTPUT);
    pinMode(in1[k],OUTPUT);
    pinMode(in2[k],OUTPUT);

    pid[k].setParams(2,0.1,0,255);
  }
  
  attachInterrupt(digitalPinToInterrupt(enca[0]),readEncoder<0>,RISING);
  attachInterrupt(digitalPinToInterrupt(enca[1]),readEncoder<1>,RISING);
  
  Serial.println("target pos");

  pinMode(digital_pin, INPUT);

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
  Serial2.println(String(u1)+","+String(u2)+","+String(u3)+","+String(u4)+","+String(u5)+","+String(u6)+","+String(u7)+","+String(i1));

}


void sensor_average(){

  u1 = 0;
  u2 = 0;
  u3 = 0;
  u4 = 0;
  u5 = 0;
  u6 = 0;
  u7 = 0;
  i1 = 0;
  for (int i = 0; i <= 5; i++) {
  delay(30);
  u3 = u3 + sonar1.ping_cm();
  delay(30);
  u2 = u2 + sonar2.ping_cm();
  delay(30);
  u1 = u1 + sonar3.ping_cm();
  delay(30);
  u5 = u5 + sonar4.ping_cm();
  delay(30);
  u7 = u7 + sonar5.ping_cm();
  delay(30);
  u6 = u6 + sonar6.ping_cm();
  delay(30);
  u4 = u4 + sonar7.ping_cm();
  i1 = i1 + analogRead(A1);
  }


  Serial2.println(String(u1/5)+","+String(u2/5)+","+String(u3/5)+","+String(u4/5)+","+String(u5/5)+","+String(u6/5)+","+String(u7/5)+","+String(i1/5));

}

void ir(){
  i1 = analogRead(A1);
  Serial.print(" I1: ");
  Serial.println(i1);

}



void IR_line_track(){
  value = digitalRead(digital_pin);
  Serial.print("Digital Reading: ");
  Serial.println(value);
  
} 



void loop() {

if (Serial2.available()>0){
  char ch2 = Serial2.read();

  Serial.write(ch2);

  if (ch2 == 's') {
    sensor_average();

  }

  if (ch2 == 'f') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 145; //Forward by 3 inches
      target[1] = -145;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);
  
  }


      else if (ch2 == 'm') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 60; //Forward by 1.5 inches
      target[1] = -60;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);
  }

  else if (ch2 == '@') {
      posi[0]=0;
      posi[1]=0;
      target[0] = -45; //5 right
      target[1] = -45;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);
  }

  else if (ch2 == '#') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 45; //5 left
      target[1] = 45;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);
  }


      else if (ch2 == 'u') { // Move gripper down
            for (pos1 = 0; pos1 <= 45; pos1 += 1){ //move down 45 deg
              lservo.write(pos1);
              delay(50);
            }
            for (pos3 = 5; pos3 <= 120; pos3 += 1){ //open
              sservo.write(pos3);
              delay(20);
            }
            for (pos1 = 45; pos1 <= 97; pos1 += 1){ //move down 45 deg
              lservo.write(pos1);
              delay(50);
            }
      Serial.println(ch2);
  }

        else if (ch2 == 'i') { // Move gripper up

          for (pos1 = 97; pos1 >= 0; pos1 -= 1){ //move down 45 deg
            lservo.write(pos1);
            delay(50);
          }
      Serial.println(ch2);
  }


  else if (ch2 == 'o') { // Close gripper

              for (pos3 = 120; pos3 >= 18; pos3 -= 1){
                sservo.write(pos3);
                delay(20);
              }
      Serial.println(ch2);
  }


  else if (ch2 == 'h') { // Open gripper

              for (pos3 = 18; pos3 <= 90; pos3 += 1){
                sservo.write(pos3);
                delay(20);
              }
      Serial.println(ch2);
  }



    else if (ch2 == '3') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 120; //Forward by 3 inches
      target[1] = -120;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);
  }

      else if (ch2 == '4') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 110; //Forward by 3 inches
      target[1] = -110;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);
  }



    else if (ch2 == '1'){
      posi[0]=0;
      posi[1]=0;

      posi_counter_r = 0;
      posi_counter_l = 0;

      target[0] = -70; //90 right
      target[1] = -70;
      control();
      delay(50);
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];

      posi[0]=0;
      posi[1]=0;
      target[0] = -70;
      target[1] = -70;
      control();
      delay(50);
      posi[0]=0;
      posi[1]=0;
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];

      target[0] = -70;
      target[1] = -70;
      control();
      delay(50);

      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      Serial2.println(String(posi_counter_r)+","+String(posi_counter_l));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }

  else if (ch2 == '2'){
      posi[0]=0;
      posi[1]=0;
      posi_counter_r = 0;
      posi_counter_l = 0;


      target[0] = 70; //90 left
      target[1] = 70;
      control();
      delay(50);
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];


      posi[0]=0;
      posi[1]=0;
      target[0] = 70;
      target[1] = 70;
      control();
      delay(50);
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];


      posi[0]=0;
      posi[1]=0;
      target[0] = 70;
      target[1] = 70;
      control();
      delay(50);

      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      Serial2.println(String(posi_counter_r)+","+String(posi_counter_l));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }


  else if (ch2 == 'n'){
      posi[0]=0;
      posi[1]=0;

      posi_counter_r = 0;
      posi_counter_l = 0;

      target[0] = -80; //Far right
      target[1] = -80;
      control();
      delay(50);
      
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      posi[0]=0;
      posi[1]=0;


      target[0] = -80; //Far right
      target[1] = -80;
      control();
      delay(50);
      
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      posi[0]=0;
      posi[1]=0;

      target[0] = -80; //Far right
      target[1] = -80;
      control();
      delay(50);

      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      Serial2.println(String(posi_counter_r)+","+String(posi_counter_l));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }

  else if (ch2 == 'c'){
      posi[0]=0;
      posi[1]=0;

      posi_counter_r = 0;
      posi_counter_l = 0;

      target[0] = 80; //Far left
      target[1] = 80;
      control();
      delay(50);
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      posi[0]=0;
      posi[1]=0;

      target[0] = 80; //Far left
      target[1] = 80;
      control();
      delay(50);
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      posi[0]=0;
      posi[1]=0;

      target[0] = 80; //Far left
      target[1] = 80;
      control();
      delay(50);
      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      Serial2.println(String(posi_counter_r)+","+String(posi_counter_l));

      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }

  

  else if (ch2 == 'x'){
      posi[0]=0;
      posi[1]=0;
      target[0] = -70; //Blindspot right
      target[1] = -70;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }

  else if (ch2 == 'y'){

      posi[0]=0;
      posi[1]=0;
      target[0] = 70; //Blindspot left
      target[1] = 70;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }

  else if (ch2 == 'r') {
      posi[0]=0;
      posi[1]=0;
      target[0] = -70; //Right by 30
      target[1] = -70;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);


  }

  else if (ch2 == 'l') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 70; //Left by 30
      target[1] = 70;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);

  }

  else if (ch2 == 'd') {

      posi[0]=0;
      posi[1]=0;
      target[0] = -60; //Right by 15
      target[1] = -60;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);

  }

  else if (ch2 == 'g') {
      posi[0]=0;
      posi[1]=0;
      target[0] = 60; //Left by 15
      target[1] = 60;
      control();
      delay(50);
      Serial2.println(String(posi[0])+","+String(posi[1]));
      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);

  }

  else if (ch2 == 'e') {
      posi[0]=0;
      posi[1]=0;


      posi_counter_r = 0;
      posi_counter_l = 0;

      
      target[0] = 160; //180 CCW
      target[1] = 160;
      control();
      delay(50);

      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];

      posi[0]=0;
      posi[1]=0;
      target[0] = 160;
      target[1] = 160;
      control();
      delay(50);

      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];

      posi[0]=0;
      posi[1]=0;
      target[0] = 160;
      target[1] = 160;
      control();
      delay(50);


      posi_counter_r = posi_counter_r + posi[0];
      posi_counter_l = posi_counter_l + posi[1];
      Serial2.println(String(posi_counter_r)+","+String(posi_counter_l));

      posi[0]=0;
      posi[1]=0;
      Serial.println(ch2);

  }

  else if (ch2 == '9'){
    analogWrite(LED, 255);

  }

    else if (ch2 == '6'){
    analogWrite(LED, 255);
    delay(500);
    analogWrite(LED, 0);
    delay(500);
    analogWrite(LED, 255);
    delay(500);
    analogWrite(LED, 0);
    delay(500);


  }

  else if (ch2 == '7'){
    analogWrite(LED, 255);
    delay(200);
    analogWrite(LED, 0);
    delay(200);
    analogWrite(LED, 255);
    delay(200);
    analogWrite(LED, 0);
    delay(200);


  }

    else if (ch2 == '!'){
    analogWrite(LED, 255);

    posi[0]=0;
    posi[1]=0;
    target[0] = -90; //Left by 15
    target[1] = 90;
    control();
    delay(50);
    posi[0]=0;
    posi[1]=0;
    Serial.println(ch2);

    for (pos1 = 0; pos1 <= 45; pos1 += 1){ //move down 45 deg
      lservo.write(pos1);
      delay(50);
    }

    for (pos1 = 45; pos1 <= 92; pos1 += 1){ //move down 45 deg
      lservo.write(pos1);
      delay(50);
    }

    for (pos3 = 18; pos3 <= 120; pos3 += 1){ //open
      sservo.write(pos3);
      delay(10);
      
    }

    Serial2.println(String(posi[0])+","+String(posi[1]));


  }

  
  }

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

  if (currT/(1.0e6)> t + 0.7){
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

