/*
 *  mTriangle.h
 *  iPadBalls
 *
 *  Created by Jonathan Beilin on 10/28/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#pragma once
#include "ofMain.h"
#include "settings.h"
#include <vector>
#include "Primitive.h"
#include "mLine.h"
#include "ofxALSoundPlayer.h"

class mTriangle {
public:
	mTriangle(ofPoint vert1, ofPoint vert2, ofPoint vert3);
	~mTriangle();
	
	bool hasSounded;
	
	vector<mLine*> lines;
	
	void draw();
	
	// void addLine(ofPoint v1, ofPoint v2);
	
	// just update the constituent parts
	void update(float dt, ofPoint touch);
	bool isCompleted();
};