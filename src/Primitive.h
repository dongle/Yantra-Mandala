/*
 *  Primitive.h
 *  iPadBalls
 *
 *  Created by Jonathan Beilin on 10/28/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#pragma once
#include "ofMain.h"
#include "settings.h"

class Primitive {
public:
	Primitive(ofPoint p, int r);
	~Primitive();
	
	ofPoint pos;
	int rotation;
	float touchTimer;
	bool completed;
	bool hasSounded;
	bool touched;
	
	float fadeInTimer;
	
	void update(float dt, ofPoint touch);
	void draw();
};