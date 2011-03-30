/*
 *  mCircle.mm
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

#include "mCircle.h"

#include "mSoundManager.h"

extern int linesCompleted;

mCircle::mCircle(ofPoint o, int r) {
	origin = o;
	radius = r;
	
	// find circumference of circle
	int circumference = 2 * PI * radius;
	
	// find number of primitives
	float numPrims = circumference/RADIUS;
	
	// find delta angle
	float dA = RADIANS(360/(float) numPrims);
	
	ofPoint p;
	
	// plot the primitives
	for (int i = 0; i < numPrims; i++) {
		p.x = o.x + radius*cos(i*dA);
		p.y = o.y + radius*sin(i*dA);
		
		prims.push_back((Primitive *) new Primitive(p, 0));
	}
	
	hasSounded = false;
	
}

mCircle::~mCircle() {
	
}

void mCircle::update(float dt, ofPoint touch) {
	for (int i = prims.size()-1; i>=0; i--) {
		prims[i]->update(dt, touch);
	}
}

void mCircle::draw() {
	for (int i = prims.size()-1; i>=0; i--) {
		prims[i]->draw();
	}
}

bool mCircle::isCompleted() {
	bool comp = true;
	
	for (int i = prims.size()-1; i>=0; i--) {
		if (prims[i]->completed == false) {
			comp = false;
		}
	}
	
	if (comp == true && hasSounded == false) {
		// play sound
		mSoundManager::playSound();
		hasSounded = true;
		linesCompleted++;
	}
	
	return comp;
}