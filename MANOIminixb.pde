/*
 *  MANOIminixb.c
 *  
 *
 *  Created by Erin Kennedy on 10-11-24.
 *  Copyright 2010 robotgrrl.com. All rights reserved.
 *
 */

#include <NewSoftSerial.h>
#include <Streaming.h>

boolean debug = false;

// All the pins
int interruptOutgoing = 6;
int interruptIncoming = 2;
int MANOIrx = 5;
int MANOItx = 4;
int LED = 3;

// NewSoftSerial
NewSoftSerial nssMANOI(MANOIrx, MANOItx);

// Trigger flag
volatile boolean triggerFlag = false;


// Initialize
void setup() {

	if(debug) Serial << "MANOI Comm. beginning initialization" << endl;
	
	// Communication
	Serial.begin(9600);
	nssMANOI.begin(9600);
	
	// Outputs
	pinMode(LED, OUTPUT);
	
	// Interrupts
	pinMode(interruptOutgoing, OUTPUT);
	attachInterrupt(0, trigger, RISING);
	
	if(debug) Serial << "Done init" << endl;
	
}

void loop() {

	if(nextXB() == 'E') {
		
		if(debug) Serial << "Byte is E" << endl;
		
		// Send out the interrupt
		digitalWrite(interruptOutgoing, HIGH);
		delay(50);
		digitalWrite(interruptOutgoing, LOW);
		
		while(!triggerFlag) {
			
			// Waiting for trigger to send the data
			if(debug) Serial << "Waiting for the trigger" << endl;
			digitalWrite(LED, HIGH);
			delay(100);
			digitalWrite(LED, LOW);
			delay(100);
			
		}
		
		if(triggerFlag) {
			
			// Sending the message now
			nssMANOI.print("E");
			
			if(debug) Serial << "Sending the message now" << endl;
			
			digitalWrite(LED, HIGH);
			delay(1000);
			digitalWrite(LED, LOW);
			
			triggerFlag = false;
			
		}
		
	}
	
}

void trigger() {
	triggerFlag = true;
}

byte nextXB() {
	
	if(debug) Serial << "Waiting for a byte" << endl;
	
	while(1) {
		
		if(Serial.available() > 0) {
			byte b = Serial.read();
			if(debug) Serial << b << endl;
			return b;
		}
		
	}
}

