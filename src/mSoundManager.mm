/*
 *  mSoundManager.cpp
 *  Yantra Mandala
 *
 *  Created by Jonathan Beilin on 10/28/10.
 *  Copyright 2010 Jonathan Beilin. All rights reserved.
 *
 This file is part of Yantra Mandala.
 
 Yantra Mandala is free software: you can redistribute it and/or modify
 it under the terms of the Lesser GNU General Public License as published by
 the Free Software Foundation.
 
 Yantra Mandala is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Yantra Mandala.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "mSoundManager.h"

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxALSoundPlayer.h"
#include <vector>

static ofxALSoundPlayer tones[7];
static ofxALSoundPlayer sandTones[3];
static int lastTone;
static int lastSandTone;

void mSoundManager::addSounds() {
	
	// ofxALSoundPlayer tones[7];
	
	/*
	tones[0].loadSound("tone1.caf");
	tones[1].loadSound("tone2.caf");
	tones[2].loadSound("tone3.caf");
	tones[3].loadSound("tone4.caf");
	tones[4].loadSound("tone5.caf");
	tones[5].loadSound("tone6.caf");
	tones[6].loadSound("tone7.caf"); 
	 */
	
	tones[0].loadSound("tone1.wav");
	tones[0].setVolume(1.0);
	tones[1].loadSound("tone2.wav");
	tones[1].setVolume(1.0);
	tones[2].loadSound("tone3.wav");
	tones[2].setVolume(1.0);
	tones[3].loadSound("tone4.wav");
	tones[3].setVolume(1.0);
	tones[4].loadSound("tone5.wav");
	tones[4].setVolume(1.0);
	tones[5].loadSound("tone6.wav");
	tones[5].setVolume(1.0);
	tones[6].loadSound("tone7.wav"); 
	tones[6].setVolume(1.0);
	
	lastTone = 7;
	
	sandTones[0].loadSound("sanddrop1.wav");
	sandTones[0].setVolume(1.0);
	sandTones[1].loadSound("sanddrop2.wav");
	sandTones[1].setVolume(1.0);
	sandTones[2].loadSound("sanddrop3.wav");
	sandTones[2].setVolume(1.0);
	
	lastSandTone = 3;
	
}

void mSoundManager::playSound() {
	int soundIndex = arc4random() % 6;
	
	while (soundIndex == lastTone) {
		soundIndex = arc4random() % 6;	
	}
	
	lastTone = soundIndex;
	
	//__sounds[soundIndex].play();
	tones[soundIndex].setVolume(1.0);
	tones[soundIndex].play();
	//printf("should be playing sound \n");
}

void mSoundManager::playSand() {
	int soundIndex = arc4random() % 2;
	
	while (soundIndex == lastTone) {
		soundIndex = arc4random() % 2;	
	}
	
	lastTone = soundIndex;
	
	//__sounds[soundIndex].play();
	sandTones[soundIndex].setVolume(1.0);
	sandTones[soundIndex].play();
}

void mSoundManager::cleanup() {
	for (int i = 0; i < 7; i++) {
		tones[i].unloadSound();
	}
}