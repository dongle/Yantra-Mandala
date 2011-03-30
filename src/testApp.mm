#include "testApp.h"

int linesCompleted;

//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofxRegisterMultitouch(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	ofEnableAlphaBlending();
	
	xsize = 768;
	ysize = 1024;
	
	sand.allocate(xsize, ysize, OF_IMAGE_COLOR_ALPHA);
	sand.update();
	
	oldLayer.allocate(xsize, ysize, OF_IMAGE_COLOR_ALPHA);
	oldLayer.update();
	
	sandPixels = sand.getPixels();
	oldPixels = oldLayer.getPixels();
	pixelArraySize = sand.width * sand.height;
	
	refreshButton.loadImage("refresh.png");
	infoButton.loadImage("info.png");
	
	lastTouch = NULL;
	
	layerNum = 0;
	lineNum = 0;
	oldSand = false;
	infoDisplayed = false;
	
	linesCompleted = 0;
	
	setUpGeometry();
	
	ofSoundSetVolume(1.0);
	mSoundManager::addSounds();
	drone.setVolume(1.0);
	drone.loadBackgroundMusic("drone.mp3", false, true);
	drone.startBackgroundMusic();
	
	infoFont.loadFont("px10.ttf", 22);
	
	shakes = 0;
	completed = false;
	
	trig = 0;
	startshake = 0;
	shake = 0;
	
	y_trig = 0;
	y_startshake = 0;
	
	timeofgesture   = 500;
	f_threshold   = 1.5;
    
    infoString = "Touch the squares displayed on screen until they \nfade away. The sound of sand dropping will play \neach time a square is completed. When all the \nsquares in the outline of a shape have been \ntouched, a new shape will appear.\n\nBy Jonathan Beilin with sound by Rich Vreeland";
    shakeString = "SHAKE";
    
    // debug
    //layerNum = 8;
    //linesCompleted = TOTALLINES - 2;
}


//--------------------------------------------------------------
void testApp::update() {
	
	if (infoDisplayed) {
		return;
	}
	
	if (!completed) {
		//sandPixels = layers[layerNum].getPixels();
		sandPixels = sand.getPixels();
		oldPixels = oldLayer.getPixels();
		
		// draw scattered sand at last touch point
		
		int pos;
		int x = lastTouch.x;
		int y = lastTouch.y;
		int r, g, b, alpha;
		
		float dt = .016;
		// float dt = .2;
		
		if (lastTouch != NULL && !oldSand) {
			for (int i = 0; i < 20; i++) {
				int xoffset = arc4random() % 15;
				int yoffset = arc4random() % 15;
				
				xoffset -= 7;
				yoffset -= 7;
				
				// change R value
				pos = (xsize*(y + yoffset) + (x + xoffset)) * 4;
				r = colors[layerNum]->r;
				sandPixels[pos] = r;
				oldPixels[pos] = r;
				//printf("R: %d \n", r);
				
				// change G value
				g = colors[layerNum]->g;
				sandPixels[pos+1] = g;
				oldPixels[pos+1] = g;
				//printf("G: %d \n", g);
				
				// change B value
				b = colors[layerNum]->b;
				sandPixels[pos+2] = b;
				oldPixels[pos+2] = b;
				//printf("G: %d \n", b);
				
				// change A value
				alpha = arc4random() % 20;
				sandPixels[pos+3] = 55 + (alpha * 10); 
				oldPixels[pos+3] = 55 + (alpha * 10); 
			}
		}
		

		
		if (layerNum < NUMTRIANGLES) {
			triangles[layerNum]->update(dt, lastTouch);
			
			if (triangles[layerNum]->isCompleted()) {
				layerNum++;	
				oldSand = true;
				//printf("linesCompleted: %d \n", linesCompleted);
			}
		}
		else if (layerNum == NUMTRIANGLES) {
			circle->update(dt, lastTouch);
			
			if (circle->isCompleted()) {
				layerNum++;	
				oldSand = true;
				//printf("linesCompleted: %d \n", linesCompleted);
			}
		}
		else {
			for (int i = 0; i < NUMLINES; i++) {
				lines[i]->update(dt, lastTouch);
				lines[i]->isCompleted();
				//printf("linesCompleted: %d \n", linesCompleted);
			}
			if (linesCompleted >= TOTALLINES) {
				oldSand = true;
				completed = true;
			}
		}
		
		if (oldSand) {
			sand.clear();
			sand.allocate(xsize, ysize, OF_IMAGE_COLOR_ALPHA);
		}
		
		sand.update();
		oldLayer.update();
	}
	
	else {
		
		if (detectShake()) {
			int yoffset,xoffset,offset;
			int newPos;
			//printf("shake");
			shakes++;
			for (int i=0; i < pixelArraySize; i++){
				// try moving each constituent value a random amount
				yoffset = arc4random() % 15;
				xoffset = arc4random() % 15;
				offset = ((yoffset * 768) + xoffset) * 4;
				newPos = i*4;
				oldPixels[newPos+offset] = oldPixels[newPos];
				oldPixels[newPos+offset+1] = oldPixels[newPos+1];
				oldPixels[newPos+offset+2] = oldPixels[newPos+2];
				oldPixels[newPos+offset+3] = oldPixels[newPos+3];
			}
			sand.update();
			oldLayer.update();	
			
			if (shakes > MAXSHAKES) {
				restartScene();
			}
		}
	}
}

//--------------------------------------------------------------
void testApp::draw() {
	

	ofPushStyle();
	if (linesCompleted < 22) {
		ofSetColor(255,255,255,127);
		oldLayer.draw(0,0);
	}
	else if (!completed) {
		int alpha = ofLerp(96, 255, (float) linesCompleted/35.0);
		ofSetColor(255,255,255,alpha);
		oldLayer.draw(0,0);
	}
	else if (completed) {
		int alpha = ofLerp(255, 32, (float) shakes/MAXSHAKES);
		ofSetColor(255,255,255,alpha);
		oldLayer.draw(0,0);
        ofSetColor(255,255,255,alpha/3.0);
        infoFont.drawString(shakeString, 325,100);
	}
	
	
	ofPopStyle();
	
	// draw guides
	if (!completed) {
		if (layerNum < NUMTRIANGLES) {
			triangles[layerNum]->draw();
		}
		else if (layerNum == NUMTRIANGLES) {
			circle->draw();
		}
		else {
			for (int i = 0; i < NUMLINES; i++) {
				lines[i]->draw();
			}
		}	
	}
	
	// draw current layer

	//layers[layerNum].draw(0,0);
	if (!completed) {
	sand.draw(0,0);
	}
	
	// draw buttons
	infoButton.draw(xsize - 30, ysize-30);
	refreshButton.draw(32, ysize-32);
	
	// draw info if active
	if (infoDisplayed) {
		
		ofRectangle rect = infoFont.getStringBoundingBox(infoString, 50,200);
		
		ofPushStyle();
		
		ofSetColor(128,128,128);
		ofRect(rect.x+5, rect.y+5, rect.width+10, rect.height+10);
		
		ofSetColor(255,255,255);
		ofRect(rect.x-5, rect.y-5, rect.width+10, rect.height+10);
		
		ofSetColor(0,0,0);
		ofRect(rect.x, rect.y, rect.width, rect.height);
		
		ofPopStyle();
		
		ofSetColor(255, 255, 255);
		infoFont.drawString(infoString, 50, 200);
	}
    
//    ofSetColor(255, 255, 255, 96);
//    infoFont.drawString(shakeString, 325,100);
}

//--------------------------------------------------------------
void testApp::exit() {
	printf("exit()\n");
	
	// cleanup sound
	drone.unloadAllBackgroundMusic();
	mSoundManager::cleanup();
	
	
	// delete sand;
	sandPixels = 0;
	
	// unload layers
	for (int i = 0; i < 11; i++) {
		//delete layers[i];
		//layers[i] = NULL;
	}
	
	// unload triangles
	for (int i = 0; i < 9; i++) {
		triangles[i] = NULL;	
	}
	
	// unload lines
	for (int i = 0; i< 36; i++) {
		lines[i] = NULL;	
	}
	
	// unload circle
	circle = NULL;
	
	// cleanup colors
	for (int i = 0; i < 9; i++) {
		colors[i] = NULL;	
	}
	
	// cleanup other stuff
	lastTouch = NULL;
	oldSand = NULL;
}

void testApp::restartScene() {
	// reset layernum
	layerNum = 0;
	lineNum = 0;
	linesCompleted = 0;
	completed = false;
	shakes = 0;
	
	// reset lastTouch and oldSand
//	lastTouch = NULL;
	oldSand = false;
	infoDisplayed = false;
	
	// reset geometry
	setUpGeometry();
	
	// clear sand layers	
	
	sand.clear();
	sand.allocate(xsize, ysize, OF_IMAGE_COLOR_ALPHA);
	sand.update();
	
	
	oldLayer.clear();
	oldLayer.allocate(xsize, ysize, OF_IMAGE_COLOR_ALPHA);
	oldLayer.update();
}

//--------------------------------------------------------------
void testApp::touchDown(int x, int y, int id){
	// printf("touch %i down at (%i,%i)\n", id, x,y);
	lastTouch.set(x, y, 0);
}

//--------------------------------------------------------------
void testApp::touchMoved(int x, int y, int id){
	// printf("touch %i moved at (%i,%i)\n", id, x, y);
	lastTouch.set(x, y, 0);
}

//--------------------------------------------------------------
void testApp::touchUp(int x, int y, int id){
	// printf("touch %i up at (%i,%i)\n", id, x, y);
	
	lastTouch = NULL;
	oldSand = false;
	infoDisplayed = false;
	
	int buttonPadding = 64;
	
	if ((x >= (xsize - buttonPadding)) && (y >= (ysize - buttonPadding))) {
		// do info stuff
		infoDisplayed = true;
	}
	
	if ((x <= (buttonPadding)) && (y >= (ysize - buttonPadding))) {
		// do restart stuff		
		restartScene();
	}
	
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(int x, int y, int id){
	//printf("touch %i double tap at (%i,%i)\n", id, x, y);
}

//--------------------------------------------------------------
void testApp::lostFocus() {
}

//--------------------------------------------------------------
void testApp::gotFocus() {
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning() {
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
}

int testApp::detectShake()
{
	
	// detect x shake
	f_x=ofxAccelerometer.getForce().x;
	
	// back
	if(f_x < -f_threshold && trig == 0){
		trig = 1;
		startshake = ofGetElapsedTimeMillis();
	}
	// forth
	if(f_x > f_threshold && trig == 1){
		trig=2;
	}
	
	// back 
	if(f_x < -f_threshold && trig == 2){
		trig=3;
	}
	
	// forth
	if(f_x > f_threshold && trig == 3){
		shake++;
		trig=0;
	}
	if ((ofGetElapsedTimeMillis() - startshake) > timeofgesture) {
		trig=0;
	}
	
	// detect y shake
	if(!shake){
		f_y=ofxAccelerometer.getForce().y; 
		
		// back
		if(f_y < -f_threshold && y_trig == 0){
			y_trig = 1;
			y_startshake = ofGetElapsedTimeMillis();
		}
		// forth
		if(f_y > f_threshold && y_trig == 1){
			y_trig=2;
		}
		
		// back 
		if(f_y < -f_threshold && y_trig == 2){
			y_trig=3;
		}
		
		// forth
		if(f_y > f_threshold && y_trig == 3){
			shake++;
			y_trig=0;
		}
		if ((ofGetElapsedTimeMillis() - y_startshake) > timeofgesture) {
			y_trig=0;
		}
	}//if !x shake, test y shake
	
	shaken = shake;
	
	shake = 0;
	
	return(shaken);
}

void testApp::setUpGeometry() {
	// set up triangles
	
	triangles[0] = (mTriangle *) new mTriangle(ofPoint(274, 546), ofPoint(385, 322), ofPoint(487, 546));
	triangles[1] = (mTriangle *) new mTriangle(ofPoint(230, 490), ofPoint(385, 225), ofPoint(537, 490));
	triangles[2] = (mTriangle *) new mTriangle(ofPoint(166, 438), ofPoint(385, 165), ofPoint(595, 438));
	triangles[3] = (mTriangle *) new mTriangle(ofPoint(312, 350), ofPoint(385, 490), ofPoint(454, 350));
	triangles[4] = (mTriangle *) new mTriangle(ofPoint(175, 322), ofPoint(385, 600), ofPoint(593, 322));
	triangles[5] = (mTriangle *) new mTriangle(ofPoint(240, 270), ofPoint(385, 550), ofPoint(527, 270));
	triangles[6] = (mTriangle *) new mTriangle(ofPoint(273, 220), ofPoint(385, 410), ofPoint(494, 220));
	
	// set up circle
	circle = new mCircle(ofPoint(384, 512), 250);
	
	
	// set up lines
	lines[0] = (mLine *) new mLine(ofPoint(215, 40), ofPoint(535, 40));
	lines[1] = (mLine *) new mLine(ofPoint(535, 40), ofPoint(535, 74));
	lines[2] = (mLine *) new mLine(ofPoint(535, 74), ofPoint(450, 74));
	lines[3] = (mLine *) new mLine(ofPoint(450, 74), ofPoint(450, 115));
	lines[4] = (mLine *) new mLine(ofPoint(450, 115), ofPoint(654, 115));
	
	lines[5] = (mLine *) new mLine(ofPoint(654, 115), ofPoint(654, 305));
	lines[6] = (mLine *) new mLine(ofPoint(654, 305), ofPoint(683, 305));
	lines[7] = (mLine *) new mLine(ofPoint(683, 305), ofPoint(683, 205));
	lines[8] = (mLine *) new mLine(ofPoint(683, 205), ofPoint(720, 205));
	lines[9] = (mLine *) new mLine(ofPoint(720, 205), ofPoint(720, 550));
	
	lines[10] = (mLine *) new mLine(ofPoint(720, 550), ofPoint(670, 550));
	lines[11] = (mLine *) new mLine(ofPoint(670, 550), ofPoint(670, 450));
	lines[12] = (mLine *) new mLine(ofPoint(670, 450), ofPoint(640, 450));
	lines[13] = (mLine *) new mLine(ofPoint(640, 450), ofPoint(640, 650));
	lines[14] = (mLine *) new mLine(ofPoint(640, 650), ofPoint(450, 650));
	
	lines[15] = (mLine *) new mLine(ofPoint(450, 650), ofPoint(450, 680));
	lines[16] = (mLine *) new mLine(ofPoint(450, 680), ofPoint(550, 680));
	lines[17] = (mLine *) new mLine(ofPoint(550, 680), ofPoint(550, 720));
	lines[18] = (mLine *) new mLine(ofPoint(550, 720), ofPoint(215, 720));
	lines[19] = (mLine *) new mLine(ofPoint(215, 720), ofPoint(215, 680));
	
	lines[20] = (mLine *) new mLine(ofPoint(215, 680), ofPoint(310, 680));
	lines[21] = (mLine *) new mLine(ofPoint(310, 680), ofPoint(310, 640));
	lines[22] = (mLine *) new mLine(ofPoint(310, 640), ofPoint(110, 640));
	lines[23] = (mLine *) new mLine(ofPoint(110, 640), ofPoint(110, 450));
	lines[24] = (mLine *) new mLine(ofPoint(110, 450), ofPoint(70, 450));
	
	lines[25] = (mLine *) new mLine(ofPoint(70, 450), ofPoint(70, 550));
	lines[26] = (mLine *) new mLine(ofPoint(70, 550), ofPoint(40, 550));
	lines[27] = (mLine *) new mLine(ofPoint(40, 550), ofPoint(40, 210));
	lines[28] = (mLine *) new mLine(ofPoint(40, 210), ofPoint(80, 210));
	lines[29] = (mLine *) new mLine(ofPoint(80, 210), ofPoint(80, 310));
	
	lines[30] = (mLine *) new mLine(ofPoint(80, 310), ofPoint(120, 310));
	lines[31] = (mLine *) new mLine(ofPoint(120, 310), ofPoint(120, 110));
	lines[32] = (mLine *) new mLine(ofPoint(120, 110), ofPoint(300, 110));
	lines[33] = (mLine *) new mLine(ofPoint(300, 110), ofPoint(300, 70));
	lines[34] = (mLine *) new mLine(ofPoint(300, 70), ofPoint(210, 70));
	
	lines[35] = (mLine *) new mLine(ofPoint(210, 70), ofPoint(210, 40));
	
	 
	
	// set up colors
	// red
	colors[0] = new ofColor();
	colors[0]->r = 205;
	colors[0]->g = 68;
	colors[0]->b = 89;
	colors[0]->a = 0;
	
	// orange
	colors[1] = new ofColor();
	colors[1]->r = 201;
	colors[1]->g = 130;
	colors[1]->b = 73;
	colors[1]->a = 255;
	
	// yellow
	colors[2] = new ofColor();
	colors[2]->r = 206;
	colors[2]->g = 215;
	colors[2]->b = 150;
	colors[2]->a = 255;
	
	colors[3] = new ofColor();
	colors[3]->r = 205;
	colors[3]->g = 68;
	colors[3]->b = 89;
	colors[3]->a = 255;
	
	colors[4] = new ofColor();
	colors[4]->r = 201;
	colors[4]->g = 130;
	colors[4]->b = 73;
	colors[4]->a = 255;
	
	colors[5] = new ofColor();
	colors[5]->r = 206;
	colors[5]->g = 215;
	colors[5]->b = 150;
	colors[5]->a = 255;
	
	colors[6] = new ofColor();
	colors[6]->r = 205;
	colors[6]->g = 68;
	colors[6]->b = 89;
	colors[6]->a = 255;
	
	// circle

	// green
	colors[7] = new ofColor();
	colors[7]->r = 20;
	colors[7]->g = 166;
	colors[7]->b = 153;
	colors[7]->a = 255;
	
	// borders
	// blue	
	colors[8] = new ofColor();
	colors[8]->r = 30;
	colors[8]->g = 60;
	colors[8]->b = 150;
	colors[8]->a = 255;	
}