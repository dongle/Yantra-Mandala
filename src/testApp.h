#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxALSoundPlayer.h"

#include "settings.h"
#include "Primitive.h"
#include "mTriangle.h"
#include "mCircle.h"

#include "mSoundManager.h"


class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();

	void touchDown(int x, int y, int id);
	void touchMoved(int x, int y, int id);
	void touchUp(int x, int y, int id);
	void touchDoubleTap(int x, int y, int id);
	
	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
	int detectShake();
	
	void setUpGeometry();
	
	void restartScene();
	
	ofImage sand;
	ofImage oldLayer;
	ofImage refreshButton;
	ofImage infoButton;
	unsigned char *sandPixels;
	unsigned char *oldPixels;
	int layerNum;
	int xsize, ysize;
	
	//ofImage layers[11];
	mTriangle *triangles[9];
	ofPoint lastTouch;
	mCircle *circle;
	
	mLine *lines[36];
	
	int lineNum;
	int outlineNum;
	int shakes;
	
	int pixelArraySize;
	
	ofColor *colors[9];
	
	bool oldSand, infoDisplayed, completed;
	
	ofTrueTypeFont infoFont;
	
	ofxALSoundPlayer drone;
	
	// mMessage *messages[10];
	
	int trig, startshake, shake, shaken, y_trig, y_startshake, timeofgesture;
	float f_threshold, f_x, f_y;
    
    string infoString, shakeString;
};
