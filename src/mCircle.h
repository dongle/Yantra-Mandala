/*
 *  mCircle.h
 *  mandala
 *
 *  Created by Jonathan Beilin on 10/29/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#pragma once
#include "ofMain.h"
#include "settings.h"
#include <vector>
#include "Primitive.h"

class mCircle {
public:
	mCircle(ofPoint o, int r);
	~mCircle();
	
	bool hasSounded;
	
	ofPoint origin;
	int radius;
	
	vector<Primitive*> prims;
	
	void draw();
	
	// just update the constituent parts
	void update(float dt, ofPoint touch);
	bool isCompleted();
	
	
};