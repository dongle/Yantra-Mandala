/*
 *  mLine.h
 *  mandala
 *
 *  Created by Jonathan Beilin on 10/30/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#pragma once
#include "ofMain.h"
#include "settings.h"
#include <vector>
#include "Primitive.h"

class mLine {
public:
	mLine(ofPoint vert1, ofPoint vert2);
	~mLine();
	
	bool hasSounded;
	
	vector<Primitive*> prims;
	
	void draw();
	
	void update(float dt, ofPoint touch);
	bool isCompleted();
	
};