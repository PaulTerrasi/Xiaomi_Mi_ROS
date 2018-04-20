int incomingByte = 0;
void setup() {
  // put your setup code here, to run once:
Serial.begin(115200);
Serial1.begin(115200);
Serial.println("start");
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial1.available() > 0){
    incomingByte = Serial1.read();
   //Serial.println(Serial1.read());
   Serial.write(incomingByte);
  }
}
