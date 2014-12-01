//
//  pageGame.h
//  See Me Choose
//
//  Created by Ian on 11/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#define NUM_CAT 4
#define NUM_PIC 20

#define B1_X 71
#define B1_X2 177
#define B2_X 317
#define B2_X2 703
#define B3_X 563
#define B4_X 809
#define BN_Y 482
#define BN_S 144
#define BC_X 441
#define BC_Y 120

#define TUNE_NONE 0
#define TUNE_CONG_1 1
#define TUNE_WELL_DONE 2
#define TUNE_CONG_2 3

@interface pageGame : NSObject {
	id owner;
	UIView *view;
	UIView *topScreen;
	NSMutableArray *thePics;
	UIButton *theButton;
	UIImageView *rightPic;
	float buttonReturn;
	NSInteger currentTune;
	NSMutableArray *wordLibraries;
	NSString *correctWord;
	NSInteger correctPic;
	NSMutableArray *successTunes;
	AVAudioPlayer *avPlayer;
	AVAudioPlayer *impactPlayer1;
	AVAudioPlayer *impactPlayer2;
	AVAudioPlayer *impactPlayer3;
	AVAudioPlayer *impactPlayer4;
	NSTimer *iTimer;
	NSTimer *pTimer;
	NSTimer *vTimer;
	NSTimer *impTimer1;
	NSTimer *impTimer2;
	NSTimer *impTimer3;
	NSTimer *impTimer4;
	UIImageView *hCLight;
	UIImageView *hLight;
}
- (id) init:(id)vOwner avPlayer:(AVAudioPlayer *)inPlayer;
- (void)displayGame;
@property NSInteger currentTune;
@property UIButton *theButton;
@property float buttonReturn;
@end
