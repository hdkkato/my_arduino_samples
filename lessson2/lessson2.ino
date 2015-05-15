int switchState = 0;

void setup() {
  // put your setup code here, to run once:
  pinMode(5, OUTPUT);  // red LED
  pinMode(4, OUTPUT);  // red LED
  pinMode(3, OUTPUT);  // green LED
  pinMode(2, INPUT);   // switch
}

void loop() {
  // put your main code here, to run repeatedly:
  switchState = digitalRead(2);
  if (switchState == LOW) {
    // the button is not pressed
    digitalWrite(3, HIGH);
    digitalWrite(4, LOW);
    digitalWrite(5, LOW);
  }
  else {
    // the button is pressed
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
    digitalWrite(5, HIGH);
    delay(250);  // wait for a quarter second
    // toggle the LEDs
    digitalWrite(4, HIGH);
    digitalWrite(5, LOW);
    delay(250);  // wait for a quater second
  }
}
