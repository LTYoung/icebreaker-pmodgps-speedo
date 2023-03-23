// Include the ArduinoBLE library
#include <ArduinoBLE.h>

// Define the TX and RX pins
#define TX_PIN 1
#define RX_PIN 0

// Create a Serial object for UART communication
//SerialUART uart(TX_PIN, RX_PIN);

// Define the messages to send to the GPS module
const char* baudRateMessage = "$PMTK251,38400*27\r\n";
const char* dataRateMessage = "$PMTK226,3,30*4\r\n";

void setup() {
  // Initialize serial communication with the computer
  Serial.begin(38400);
  Serial1.begin(38400);
  
  // Initialize UART communication with the GPS module at 9600 baud rate
  //uart.begin(9600);
  
  /*
  // Send the first message to set the baud rate to 38400
  Serial1.write(baudRateMessage);
  
  // Wait for a second
  delay(10000);
  
  // End the UART communication at 9600 baud rate
  Serial1.end();
  
  // Start the UART communication again at 38400 baud rate
  Serial1.begin(38400);
  */
  // Send the second message to set the data acquisition rate to 10Hz
  
}

void loop() {
  if(Serial1.available()){
    Serial.write(Serial1.read());
  }
  Serial1.write(dataRateMessage);
  
}