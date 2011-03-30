/*
 *  mMessage.h
 *  mandala
 *
 *  Created by Jonathan Beilin on 10/31/10.
 *  Copyright 2010 Koduco Games. All rights reserved.
 *
 */

#pragma once
#include "ofMain.h"
#include "settings.h"

class mMessage {
public:
	mMessage(const char *text);
	
	void update(float dt);
	void draw();
};