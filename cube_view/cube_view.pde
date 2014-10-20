import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String str = null;
Serial myPort;  // The serial port

int x0, y0, z0;
boolean cal = false;

void setup() {
  // List all the available serial ports
  size(800, 600, P3D);
  for (int i = 0; i < Serial.list().length; i++) {
    print(i);
    print(" ---> ");
    println(Serial.list()[i]);
  } 
  // Open the port you are using at the rate you want (change the number according to your list):
  myPort = new Serial(this, Serial.list()[9], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  str = myPort.readStringUntil('\n');
  str = null;
}

float fx = 0, fy = 0, fz = 0;

void draw() {
  while (myPort.available() > 0) {
    str = myPort.readStringUntil('\n');
    if (str != null) {
      int x, y, z, pos1, pos2, pos3;
      // parse data from serial
      pos1 = str.indexOf(":");
      pos2 = str.indexOf(":", pos1 + 1);
      pos3 = str.indexOf("\r", pos2 + 1);
      if (pos1 < 0 || pos2 < 0) return;
      x = int(str.substring(0, pos1));
      y = int(str.substring(pos1 + 1, pos2));   
      z = int(str.substring(pos2 + 1, pos3));
      // filtering
      fx = 0.1 * x + 0.9 * fx;
      fy = 0.1 * y + 0.9 * fy;
      fz = 0.1 * z + 0.9 * fz;
      // calculating angles      
      float pitch = atan2(fx, (sqrt(fy*fy + fz*fz)));
      float roll = atan2(fy, (sqrt(fx*fx + fz*fz)));
      float yaw = atan2(fz, (sqrt(fx*fx + fy*fy)));
      // display cube
      background(0);
      lights();
      noStroke();
      pushMatrix();
      translate(width/2, height/2, 0);
      rotateX(pitch);
//      rotateY(yaw); // we have actually no info about yaw, bacause we have no magnetometer
      rotateZ(-roll);
      box(100);
      popMatrix();  
    }
  }
}

