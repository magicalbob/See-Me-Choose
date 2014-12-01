//
//  ViewController.m
//  See Me Choose
//
//  Created by Ian on 10/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
	AVAudioRecorder *avRecorder;
	AVAudioPlayer *avPlayer;
}

@end

@implementation ViewController

@synthesize scaleX;
@synthesize scaleY;
@synthesize pSetup;
@synthesize pGame;
@synthesize imageLibraries;
@synthesize wordLibraries;

- (void)viewDidLoad
{
    [super viewDidLoad];

	/* Set up events to trigger when:
			the application becomes active again, to display the setup page;
			the application is about to stop being active, so that resuming is clean
    */
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self
			   selector:@selector(resumeApp)
				   name:UIApplicationWillEnterForegroundNotification
				 object:nil];
	
	[center addObserver:self
               selector:@selector(stopAllTasks)
                   name:UIApplicationWillResignActiveNotification
                 object:nil];
	
	//
    // Set the user default usePortrait to NO, so that the app displays in Landscape.
    // This parmeter is set to YES when the Photo Picker runs, as it only works in portrait mode.
    //
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"usePortrait"];

	// Work out scale compared to iPad resolution (1024 x 768) for use with different screen sizes
	if (self.view.frame.size.width > self.view.frame.size.height) {
		scaleX = self.view.frame.size.width;
		scaleY = self.view.frame.size.height;
	} else {
		scaleX = self.view.frame.size.height;
		scaleY = self.view.frame.size.width;
	}
	scaleX=scaleX/1024;
	scaleY=scaleY/768;
	
	// Build NSMutableArrays for the 4 personal albums, using URLs store in user defaults
	imageLibraries = nil;
	[self buildImageLibraries];
	
	// Build array of the 5 success tunes, for random selection later. Note that the same array is also built in the the play game class, as the success tunes are played in both classes.
	successTunes = [NSMutableArray arrayWithObjects:nil count:0];
	[successTunes addObject:@"success01"];
	[successTunes addObject:@"success02"];
	[successTunes addObject:@"success03"];
	[successTunes addObject:@"success04"];
	[successTunes addObject:@"success05"];
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"seeMeChooseAnnounce"] == nil) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"seeMeChooseAnnounce"];
	}
	
	// Display the setup page.
	pSetup = [[pageSetup alloc] init:self.view vCont:self];
	[pSetup->goButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
	pGame = nil;
}

- (void) startGame {
	// private method so that it can be linked to the goButton when view controller loaded
	pGame = [[pageGame alloc] init:self avPlayer:avPlayer];
}

- (void) stopAllTasks {
	// stop the audio player, if it's playing.
	
	if ([avPlayer isPlaying]) {
		if (pGame) {
			pGame.currentTune = TUNE_NONE;
		}
		[avPlayer stop];
	}
}

- (void)resumeApp {
	// Bring the setup page back in to focus
	
	[pSetup resumeSetup];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSString *pathCongratulations;

	/*
		Use the currentTune instance variable to track progress through success sequence.
		One last tune has played, re-start the game.
	*/

	if (pGame) {
		switch ([pGame currentTune]) {
			case TUNE_CONG_1:
			{
				[self playWellDone];
				pGame.currentTune=TUNE_WELL_DONE;
				break;
			}
			case TUNE_WELL_DONE:
			{
				[UIView animateWithDuration:4
								  delay:0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
				{
				 
					[pGame.theButton setFrame:CGRectMake(pGame.buttonReturn,BN_Y,BN_S, BN_S)];
				}
							 completion:^(BOOL finished)
				{
				 
				}];

				pathCongratulations = [[NSBundle mainBundle] pathForResource:[successTunes objectAtIndex:(rand() % 5)]
																	  ofType:@"mp3"];
				avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathCongratulations] error:nil];
				[avPlayer play];
				[avPlayer setDelegate:self];
				pGame.currentTune=TUNE_CONG_2;
				break;
			}
			case TUNE_CONG_2:
			{
				pGame.currentTune=TUNE_NONE;
				[pGame displayGame];
				break;
			}
		}
	}
}

- (void) playWellDone {
	NSString *pathCongratulations;
	NSMutableArray *pMessages;
	NSInteger randMsg;
	
	pMessages = [self getPersonalMessages];
	
	if ([pMessages count] > 0) {
		randMsg = rand() % [pMessages count];
		NSURL *temporaryRecFile = [pMessages objectAtIndex:randMsg];
		avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
		[avPlayer setDelegate:self];
		[avPlayer play];
	} else {
		pathCongratulations = [[NSBundle mainBundle] pathForResource:@"WellDone" ofType:@"mp3"];
		avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathCongratulations] error:nil];
		[avPlayer play];
		[avPlayer setDelegate:self];
	}
}

- (NSMutableArray *) getPersonalMessages {
	NSMutableArray *retArray;
	
	retArray = [NSMutableArray arrayWithObjects:nil count:0];

	//Load recording path from preferences
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	for (int mIdx = 1; mIdx <=4; mIdx++) {
		NSURL *temporaryRecFile;
		
		temporaryRecFile = [prefs URLForKey:[NSString stringWithFormat:@"seeMeChooseMessage%d",mIdx]];

		if (temporaryRecFile != nil) {
			[retArray addObject:temporaryRecFile];
		}
	}
	
	return retArray;
}

- (void) buildImageLibraries {
	ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
	
	if (imageLibraries == nil) {
		imageLibraries = [NSMutableArray arrayWithObjects:nil count:0];
		wordLibraries = [NSMutableArray arrayWithObjects:nil count:0];
	} else {
		[imageLibraries removeAllObjects];
		[wordLibraries removeAllObjects];
	}
	
	for (int aIdx = 1; aIdx <= 4; aIdx++) {
		NSMutableArray *albumN = [NSMutableArray arrayWithObjects:nil count:0];
		NSMutableArray *lexiconN = [NSMutableArray arrayWithObjects:nil count:0];
		for (int pIdx = 1; pIdx <= 20; pIdx++) {
			NSURL *testURL = [[NSUserDefaults standardUserDefaults] URLForKey:[NSString stringWithFormat:@"album%dPic%d",aIdx,pIdx]];
			if (testURL != NULL) {
				[lexiconN addObject:[NSString stringWithFormat:@"seeMeChooseTitle%dPic%d",aIdx,pIdx]];
				[assetsLibrary assetForURL:testURL resultBlock: ^(ALAsset *asset){
					CGImageRef imageRef;
					
					imageRef = [asset thumbnail];
					if (imageRef) {
						[albumN addObject:[UIImage imageWithCGImage:imageRef scale:0.5 orientation:UIImageOrientationUp]];
					}
				} failureBlock:^(NSError *error) {
					// Handle failure.
				}];
			}
		}
		[imageLibraries addObject:albumN];
		[wordLibraries addObject:lexiconN];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
