/*
 *  mLine.cpp
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

#include "mLine.h"

#include "mSoundManager.h"

extern int linesCompleted;

mLine::mLine(ofPoint v1, ofPoint v2) {
	float a, b, dist, xDist, yDist, angle, midPoint, dX, dY;
	int numPrims;
	
	// draw line 1 - v1 - v2
	
	// calculate distance
	a = (v2.x - v1.x)*(v2.x - v1.x);
	b = (v2.y - v1.y)*(v2.y - v1.y);
	
	//midPoint = (v3.x - v1.x)/2;
	
	dist = sqrt(a+b);
	
	// calculate angle
	//angle = atan(dist/midPoint);
	angle = 0;
	
	// divide distance by RADIUS to discover # of primitives to be drawn
	numPrims = dist/(float) (.8*RADIUS);
	
	// calculate total x & y distance
	xDist = v2.x - v1.x;
	yDist = v2.y - v1.y;
	
	// calculate dX and dY
	dX = xDist/(float) numPrims;
	dY = yDist/(float) numPrims;
	
	// plot primitives every RADIUS pixels along line
	for (int i = 0; i < numPrims; i++) {
		prims.push_back((Primitive *) new Primitive(ofPoint(v1.x + (i*dX), v1.y + (i*dY) + OFFSET), angle));
	}
	
	hasSounded = false;
}

mLine::~mLine() {
	
}

void mLine::draw() {
	for (int i = prims.size()-1; i>=0; i--) {
		prims[i]->draw();
	}
}

void mLine::update(float dt, ofPoint touch) {
	for (int i = prims.size()-1; i>=0; i--) {
		prims[i]->update(dt, touch);
	}
}

bool mLine::isCompleted() {
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
		printf("linesCompleted: %d \n", linesCompleted);
	}
	
	return comp;
}