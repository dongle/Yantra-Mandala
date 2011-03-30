/*
 *  mTriangle.cpp
 *  iPadBalls
 *
 *  Created by Jonathan Beilin on 10/28/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#include "mTriangle.h"

mTriangle::mTriangle(ofPoint vert1, ofPoint vert2, ofPoint vert3) {
	
	lines.push_back((mLine *) new mLine(vert1, vert2));
	lines.push_back((mLine *) new mLine(vert2, vert3));
	lines.push_back((mLine *) new mLine(vert3, vert1));
	
	hasSounded = false;
}

mTriangle::~mTriangle() {
	
}

/*
void mTriangle::addLine(ofPoint v1, ofPoint v2) {
	float a, b, dist, xDist, yDist, angle, midPoint, dX, dY;
	int numPrims;
	
	// draw line 1 - v1 - v2
	
	// calculate distance
	a = (v2.x - v1.x)*(v2.x - v1.x);
	b = (v2.y - v1.y)*(v2.y - v1.y);
	
	midPoint = (v3.x - v1.x)/2;
	
	dist = sqrt(a+b);
	
	// calculate angle
	angle = atan(dist/midPoint);
	
	// divide distance by RADIUS to discover # of primitives to be drawn
	numPrims = dist/(float) RADIUS;
	
	// calculate total x & y distance
	xDist = v2.x - v1.x;
	yDist = v2.y - v1.y;
	
	// calculate dX and dY
	dX = xDist/numPrims;
	dY = yDist/numPrims;
	
	// plot primitives every RADIUS pixels along line
	for (int i = 0; i < numPrims; i++) {
		prims.push_back((Primitive *) new Primitive(ofPoint(v1.x + (i*dX), v1.y + (i*dY) + OFFSET), angle));
	}
}
 */

void mTriangle::draw() {
	for (int i = lines.size()-1; i>=0; i--) {
		lines[i]->draw();
	}
}

void mTriangle::update(float dt, ofPoint touch) {
	for (int i = lines.size()-1; i>=0; i--) {
		lines[i]->update(dt, touch);
	}
}

bool mTriangle::isCompleted() {
	bool comp = true;
	
	for (int i = lines.size()-1; i>=0; i--) {
		if (lines[i]->isCompleted() == false) {
			comp = false;
		}
	}

	return comp;
}