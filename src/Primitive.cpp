/*
 *  Primitive.cpp
 *  iPadBalls
 *
 *  Created by Jonathan Beilin on 10/28/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#include "Primitive.h"
#include "mSoundManager.h"

Primitive::Primitive(ofPoint p, int r) {
	pos = p;
	rotation = r;
	completed = false;
	touchTimer = 0;
	fadeInTimer = .4;
	hasSounded = false;
	touched = false;
}

Primitive::~Primitive() {

}

void Primitive::update(float dt, ofPoint touch) {
	// check if touch is within primitive
	
	// check
	touched = false;
	
	if ((touch.x + PADDING >= pos.x) && (touch.x <= (pos.x + RADIUS + PADDING))
		&& (touch.y + PADDING >= pos.y) && (touch.y <= (pos.y + RADIUS + PADDING))) {
		touched = true;
	}
	
	// if so, add dt to touchTimer
	if (touched) {
		touchTimer += dt;
		
		if (touchTimer >= TOUCHTIME) {
			completed = true;	
		}
	}
	
	if (completed) {
		touchTimer += dt;
	}
	
	if (fadeInTimer >= 0) {
		fadeInTimer -= dt;
	}
	
	if (completed == true && hasSounded == false) {
		// play sound
		mSoundManager::playSand();
		hasSounded = true;
	}
}

void Primitive::draw() {
	
	if (fadeInTimer > 0) {
		ofPushStyle();

		ofFill();
		
		int alpha = ofLerp(255, 0, (fadeInTimer/TOUCHTIME));
		ofSetColor(255, 255, 255, alpha);
		
		if (touched) {
			ofRect(pos.x-.5*(RADIUS*MAGNIFICATION), pos.y-.5*(RADIUS*MAGNIFICATION), RADIUS*MAGNIFICATION, RADIUS*MAGNIFICATION);
		}
		else {
			ofRect(pos.x-.5*RADIUS, pos.y-.5*RADIUS, RADIUS, RADIUS);
		}
		
		ofPopStyle();
	}
	
	else if (!completed) {
		//ofPushMatrix();
		ofPushStyle();
		
		// transform
		//ofRotate(rotation, pos.x, pos.y, pos.z);
		ofFill();
		
		int alpha = ofLerp(255, 64, (touchTimer/TOUCHTIME));
		ofSetColor(255, 255, 255, alpha);
		
		// draw rectangle
		if (touched) {
			ofRect(pos.x-.5*(RADIUS*MAGNIFICATION), pos.y-.5*(RADIUS*MAGNIFICATION), RADIUS*MAGNIFICATION, RADIUS*MAGNIFICATION);
		}
		else {
			ofRect(pos.x-.5*RADIUS, pos.y-.5*RADIUS, RADIUS, RADIUS);
		}
		
		//ofPopMatrix();
		ofPopStyle();
	}
	
	else {
		ofPushStyle();
		
		ofFill();
		
		int alpha = ofLerp(64, 0, ((.5*touchTimer)/TOUCHTIME));
		ofSetColor(255, 255, 255, alpha);
		
		// draw rectangle
		if (touched) {
			ofRect(pos.x-.5*(RADIUS*MAGNIFICATION), pos.y-.5*(RADIUS*MAGNIFICATION), RADIUS*MAGNIFICATION, RADIUS*MAGNIFICATION);
		}
		else {
			ofRect(pos.x-.5*RADIUS, pos.y-.5*RADIUS, RADIUS, RADIUS);
		}
		
		ofPopStyle();
	}

}