//
//  pageGame.m
//  See Me Choose
//
//  Created by Ian on 11/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "pageGame.h"
#import "ViewController.h"
#import "pageSetup.h"
#import "selectCats.h"

@implementation pageGame

@synthesize currentTune;
@synthesize theButton;
@synthesize buttonReturn;

- (id) init:(id)vOwner avPlayer:(AVAudioPlayer *)inPlayer {
	self = [super init];
	
	if (self) {
		// view = containerView;
		owner = vOwner;
		view = [vOwner view];
		currentTune=TUNE_NONE;
		avPlayer = inPlayer;
		correctWord = nil;
		iTimer = nil;
		pTimer = nil;
		vTimer = nil;
		impTimer1 = nil;
		impTimer2 = nil;
		impTimer3 = nil;
		impTimer4 = nil;
		successTunes = [NSMutableArray arrayWithObjects:nil count:0];
		[successTunes addObject:@"success01"];
		[successTunes addObject:@"success02"];
		[successTunes addObject:@"success03"];
		[successTunes addObject:@"success04"];
		[successTunes addObject:@"success05"];
		[self buildWordLibraries];
		[self displayGame];
				
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self
				   selector:@selector(stopAllTasks)
					   name:UIApplicationWillResignActiveNotification
					 object:nil];
		
		[center addObserver:self
				   selector:@selector(stopAllTasks)
					   name:UIApplicationWillEnterForegroundNotification
					 object:nil];
	}
	
	return self;
}

- (void) stopAllTasks {
	// stop the audio player, if it's playing.

	if (avPlayer) {
		if ([avPlayer isPlaying]) {
			@try {
				[avPlayer stop];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impactPlayer1) {
		if ([impactPlayer1 isPlaying]) {
			@try {
				[impactPlayer1 stop];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impactPlayer2) {
		if ([impactPlayer2 isPlaying]) {
			@try {
				[impactPlayer2 stop];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impactPlayer3) {
		if ([impactPlayer3 isPlaying]) {
			@try {
				[impactPlayer3 stop];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impactPlayer4) {
		if ([impactPlayer4 isPlaying]) {
			@try {
				[impactPlayer4 stop];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}

	if (iTimer) {
		if ([iTimer isValid]) {
			@try {
				[iTimer invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (pTimer) {
		if ([pTimer isValid]) {
			@try {
				[pTimer invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (vTimer) {
		if ([vTimer isValid]) {
			@try {
				[vTimer invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impTimer1) {
		if ([impTimer1 isValid]) {
			@try {
				[impTimer1 invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impTimer2) {
		if ([impTimer2 isValid]) {
			@try {
				[impTimer2 invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impTimer3) {
		if ([impTimer3 isValid]) {
			@try {
				[impTimer3 invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
	if (impTimer4) {
		if ([impTimer4 isValid]) {
			@try {
				[impTimer4 invalidate];
			}
			@catch (NSException *exception) {
				NSLog(@"%@", exception.reason);
			}
		}
	}
}

- (void)displayGame {
	// Method to display the main game play screen
	
	// Add views to make top of screen red & bottom of screen green
	topScreen = [[UIView alloc] initWithFrame:CGRectMake(0,
																 0,
																 1024, //self.view.frame.size.width,
																 382)]; //self.view.frame.size.height / 2)] ;
	topScreen.backgroundColor = [UIColor redColor];
	[view addSubview:topScreen];
	[view bringSubviewToFront:topScreen];
	
	UIView *botScreen = [[UIView alloc] initWithFrame:CGRectMake(0,
																 382,
																 1024, //self.view.frame.size.width,
																 382)]; //self.view.frame.size.height / 2)] ;
	botScreen.backgroundColor = [UIColor greenColor];
	[view addSubview:botScreen];
	[view bringSubviewToFront:botScreen];
	
	UIImageView *gameFrame = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
	gameFrame.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"]];
	[view addSubview:gameFrame];
	[view bringSubviewToFront:gameFrame];
	
	UIImageView *aPic;
	NSMutableArray *arrImages;
	float b1FinX, b2FinX;
		
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseUse4"]) {
		correctPic = rand() % 4 + 1;
		b1FinX = B1_X;
		b2FinX = B2_X;
	} else {
		correctPic = rand() % 2 + 1;
		b1FinX = B1_X2;
		b2FinX = B2_X2;
	}

	/*
	 View controller instance includes an array to the incorrect pictures, so that we can make the disappear when the
	 correct image is pressed.
	 For each of the bottom 4 images, create either the button to trigger success or a plain image view which will do ...  nothing.
	 Add the "do nothing" picture to the array of pictures.
	 */
	
	thePics = [NSMutableArray arrayWithObjects:nil count:0];
	
	arrImages = [self getPictureSet];
	
	NSTimeInterval delay1 = ((rand() % 20) +1) /10;
	NSTimeInterval delay2 = ((rand() % 20) +1) /10;
	NSTimeInterval delay3 = ((rand() % 20) +1) /10;
	NSTimeInterval delay4 = ((rand() % 20) +1) /10;
	NSTimeInterval delayC = 0;
	
	iTimer = nil;
	
	if (correctPic==1) {
		theButton=[[UIButton alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
		[theButton setImage:[arrImages objectAtIndex:0] forState:UIControlStateNormal];
		[view addSubview:theButton];
		[view bringSubviewToFront:theButton];
		[theButton addTarget:self action:@selector(successRoutine) forControlEvents:UIControlEventTouchDown];
		[theButton setEnabled:NO];
		[theButton setAdjustsImageWhenDisabled:NO];
		delayC=delay1+2;
		[UIView animateWithDuration:2
							  delay:delay1
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^(void)
		 {
			 [theButton setFrame:CGRectMake(b1FinX,BN_Y,BN_S, BN_S)];
		 }
						 completion:^(BOOL finished)
		 {
			 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
				 iTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults]integerForKey:@"seeMeChooseSeconds"]
												  target:self
												selector:@selector(hLightImage1)
												userInfo:nil
												 repeats:NO];
			 }
			 [theButton setEnabled:YES];
		 }];
	} else {
		aPic = [[UIImageView alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
		[aPic setImage:[arrImages objectAtIndex:0]];
		[view addSubview:aPic];
		[view bringSubviewToFront:aPic];
		[thePics addObject:aPic];
		[UIView animateWithDuration:2
							  delay:delay1
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^(void)
		 {
			 [aPic setFrame:CGRectMake(b1FinX,BN_Y,BN_S, BN_S)];
		 }
						 completion:^(BOOL finished)
		 {
		 }];
	}
		
	if (correctPic==2) {
		theButton=[[UIButton alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
		[theButton setImage:[arrImages objectAtIndex:1] forState:UIControlStateNormal];
		[view addSubview:theButton];
		[view bringSubviewToFront:theButton];
		[theButton addTarget:self action:@selector(successRoutine) forControlEvents:UIControlEventTouchDown];
		[theButton setEnabled:NO];
		[theButton setAdjustsImageWhenDisabled:NO];
		delayC=delay2+2;
		[UIView animateWithDuration:2
							  delay:delay2
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^(void)
		 {
			 [theButton setFrame:CGRectMake(b2FinX,BN_Y,BN_S, BN_S)];
		 }
						 completion:^(BOOL finished)
		 {
			 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
				 iTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults]integerForKey:@"seeMeChooseSeconds"]
												  target:self
												selector:@selector(hLightImage2)
												userInfo:nil
												 repeats:NO];
			 }
			 [theButton setEnabled:YES];
		 }];
	} else {
		aPic = [[UIImageView alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
		[aPic setImage:[arrImages objectAtIndex:1]];
		[view addSubview:aPic];
		[view bringSubviewToFront:aPic];
		[thePics addObject:aPic];
		[UIView animateWithDuration:2
							  delay:delay2
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^(void)
		 {
			 [aPic setFrame:CGRectMake(b2FinX,BN_Y,BN_S, BN_S)];
		 }
						 completion:^(BOOL finished)
		 {
		 }];
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseUse4"]) {
		if (correctPic==3) {
			theButton=[[UIButton alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
			[theButton setImage:[arrImages objectAtIndex:2] forState:UIControlStateNormal];
			[view addSubview:theButton];
			[view bringSubviewToFront:theButton];
			[theButton addTarget:self action:@selector(successRoutine) forControlEvents:UIControlEventTouchDown];
			[theButton setEnabled:NO];
			[theButton setAdjustsImageWhenDisabled:NO];
			delayC=delay3+2;
			[UIView animateWithDuration:2
								  delay:delay3
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
				{
					[theButton setFrame:CGRectMake(B3_X,BN_Y,BN_S, BN_S)];
				}
							 completion:^(BOOL finished)
				{
					if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
						iTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults]integerForKey:@"seeMeChooseSeconds"]
														 target:self
													   selector:@selector(hLightImage3)
													   userInfo:nil
														repeats:NO];
					}
					[theButton setEnabled:YES];
				}];
		} else {
			aPic = [[UIImageView alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
			[aPic setImage:[arrImages objectAtIndex:2]];
			[view addSubview:aPic];
			[view bringSubviewToFront:aPic];
			[thePics addObject:aPic];
			[UIView animateWithDuration:2
								  delay:delay3
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
				{
						 [aPic setFrame:CGRectMake(B3_X,BN_Y,BN_S, BN_S)];
				}
							 completion:^(BOOL finished)
				{
				}];

		}
	
		if (correctPic==4) {
			theButton=[[UIButton alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
			[theButton setImage:[arrImages objectAtIndex:3] forState:UIControlStateNormal];
			[view addSubview:theButton];
			[view bringSubviewToFront:theButton];
			[theButton addTarget:self action:@selector(successRoutine) forControlEvents:UIControlEventTouchDown];
			[theButton setEnabled:NO];
			[theButton setAdjustsImageWhenDisabled:NO];
			delayC=delay4+2;
			[UIView animateWithDuration:2
								  delay:delay4
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
				{
					[theButton setFrame:CGRectMake(B4_X,BN_Y,BN_S, BN_S)];
				}
							 completion:^(BOOL finished)
				{
					if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
						iTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults]integerForKey:@"seeMeChooseSeconds"]
														 target:self
													   selector:@selector(hLightImage4)
													   userInfo:nil
														repeats:NO];
					}
					[theButton setEnabled:YES];
				}];
		} else {
			aPic = [[UIImageView alloc] initWithFrame:CGRectMake([self randStartX],[self randStartY],BN_S, BN_S)];
			[aPic setImage:[arrImages objectAtIndex:3]];
			[view addSubview:aPic];
			[view bringSubviewToFront:aPic];
			[thePics addObject:aPic];
			[UIView animateWithDuration:2
								  delay:delay4
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
				{
						 [aPic setFrame:CGRectMake(B4_X,BN_Y,BN_S, BN_S)];
				}
							 completion:^(BOOL finished)
				{
				}];
		}
	}
	/*
	 Finally, draw the correct picture at the top of the screen. The image can simply be set to the image of the only
	 button.
	 */
	
	pTimer = nil;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
		pTimer = [NSTimer scheduledTimerWithTimeInterval:([[NSUserDefaults standardUserDefaults]integerForKey:@"seeMeChooseSeconds"] + delayC)
										 target:self
									   selector:@selector(hLightC)
									   userInfo:nil
										repeats:NO];
	}
	rightPic = [[UIImageView alloc] initWithFrame:CGRectMake(BC_X,BC_Y,BN_S, BN_S)];
	[rightPic setImage:theButton.imageView.image];
	[view addSubview:rightPic];
	[view bringSubviewToFront:rightPic];
	
	impTimer1 = [NSTimer scheduledTimerWithTimeInterval:delay1
									 target:self
								   selector:@selector(playImpact1)
								   userInfo:nil
									repeats:NO];
	
	impTimer2 = [NSTimer scheduledTimerWithTimeInterval:delay2
									 target:self
								   selector:@selector(playImpact2)
								   userInfo:nil
									repeats:NO];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseUse4"]) {
		impTimer3 = [NSTimer scheduledTimerWithTimeInterval:delay3
										 target:self
									   selector:@selector(playImpact3)
									   userInfo:nil
										repeats:NO];
	
		impTimer4 = [NSTimer scheduledTimerWithTimeInterval:delay4
										 target:self
									   selector:@selector(playImpact4)
									   userInfo:nil
										repeats:NO];
	}
	
	vTimer=[NSTimer scheduledTimerWithTimeInterval:4
									 target:self
								   selector:@selector(sayTheWord)
								   userInfo:nil
									repeats:NO];
	
}

- (void) hLightImage1 {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
		float b1FinX;
		
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseUse4"]) {
			b1FinX = B1_X;
		} else {
			b1FinX = B1_X2;
		}
		
		UIImage *frame1, *frame2, *flashHighlight;
		NSArray *animFrames;
		frame1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightRed"
																				  ofType:@"jpg"]];
		frame2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightGreen"
																				  ofType:@"jpg"]];
		animFrames = [NSArray arrayWithObjects:frame1,frame2,nil];
		flashHighlight = [UIImage animatedImageWithImages:animFrames duration:0.2];

		hLight=[[UIImageView alloc] initWithFrame:CGRectMake(b1FinX - 10, BN_Y - 10, BN_S + 20, BN_S + 20)];
		[hLight setImage:flashHighlight];
		[view addSubview:hLight];
		[view bringSubviewToFront:hLight];
		[view bringSubviewToFront:theButton];
	}
}

- (void) hLightImage2 {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
		float b2FinX;
		
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseUse4"]) {
			b2FinX = B2_X;
		} else {
			b2FinX = B2_X2;
		}
		
		UIImage *frame1, *frame2, *flashHighlight;
		NSArray *animFrames;
		frame1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightRed"
																				  ofType:@"jpg"]];
		frame2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightGreen"
																				  ofType:@"jpg"]];
		animFrames = [NSArray arrayWithObjects:frame1,frame2,nil];
		flashHighlight = [UIImage animatedImageWithImages:animFrames duration:0.2];

		hLight=[[UIImageView alloc] initWithFrame:CGRectMake(b2FinX - 10, BN_Y - 10, BN_S + 20, BN_S + 20)];
		[hLight setImage:flashHighlight];
		[view addSubview:hLight];
		[view bringSubviewToFront:hLight];
		[view bringSubviewToFront:theButton];
	}
}

- (void) hLightImage3 {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
		UIImage *frame1, *frame2, *flashHighlight;
		NSArray *animFrames;
		frame1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightRed"
																				  ofType:@"jpg"]];
		frame2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightGreen"
																				  ofType:@"jpg"]];
		animFrames = [NSArray arrayWithObjects:frame1,frame2,nil];
		flashHighlight = [UIImage animatedImageWithImages:animFrames duration:0.2];
		
		hLight=[[UIImageView alloc] initWithFrame:CGRectMake(B3_X - 10, BN_Y - 10, BN_S + 20, BN_S + 20)];
		[hLight setImage:flashHighlight];
		[view addSubview:hLight];
		[view bringSubviewToFront:hLight];
		[view bringSubviewToFront:theButton];
	}
}

- (void) hLightImage4 {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
		UIImage *frame1, *frame2, *flashHighlight;
		NSArray *animFrames;
		frame1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightRed"
																				  ofType:@"jpg"]];
		frame2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightGreen"
																				  ofType:@"jpg"]];
		animFrames = [NSArray arrayWithObjects:frame1,frame2,nil];
		flashHighlight = [UIImage animatedImageWithImages:animFrames duration:0.2];
	
		hLight=[[UIImageView alloc] initWithFrame:CGRectMake(B4_X - 10, BN_Y - 10, BN_S + 20, BN_S + 20)];
		[hLight setImage:flashHighlight];
		[view addSubview:hLight];
		[view bringSubviewToFront:hLight];
		[view bringSubviewToFront:theButton];
	}
}

- (void) hLightC {
	UIImage *frame1, *frame2, *flashHighlight;
	NSArray *animFrames;
	frame1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightRed"
																			  ofType:@"jpg"]];
	frame2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"highlightGreen"
																			  ofType:@"jpg"]];
	animFrames = [NSArray arrayWithObjects:frame1,frame2,nil];
	flashHighlight = [UIImage animatedImageWithImages:animFrames duration:0.2];

	hCLight=[[UIImageView alloc] initWithFrame:CGRectMake(BC_X - 10, BC_Y - 10, BN_S + 20, BN_S + 20)];
	[hCLight setImage:flashHighlight];
	[view addSubview:hCLight];
	[view bringSubviewToFront:hCLight];
	[view bringSubviewToFront:rightPic];
}

- (NSMutableArray *) getPictureSet {
	NSInteger randCat;
	NSInteger numToGuess;
	NSInteger btn1, btn2, btn3, btn4;
	NSMutableArray *retSet = [[NSMutableArray alloc] initWithObjects:nil count:0];
	NSMutableArray *theCats = [[NSMutableArray alloc] initWithObjects:0 count:0];
	NSMutableArray *perLib, *perLex;
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useAnimals"]) {
		[theCats addObject:@"0"];
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useInstruments"]) {
		[theCats addObject:@"1"];
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useFood"]) {
		[theCats addObject:@"2"];
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useVehicles"]) {
		[theCats addObject:@"3"];
	}
	
	for (int pIdx=1; pIdx <= 4; pIdx++) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"usePersonal%d",pIdx]]) {
			[theCats addObject:[NSString stringWithFormat:@"0%d",pIdx - 1]];
		}
	}

	if ([theCats count]==0) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useAnimals"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useInstruments"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useFood"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useVehicles"];
		[theCats addObject:@"0"];
		[theCats addObject:@"1"];
		[theCats addObject:@"2"];
		[theCats addObject:@"3"];
		ViewController *theController = owner;
		[[[[theController pSetup] whichCats] switchAnimals] setOn:YES];
		[[[[theController pSetup] whichCats] switchInstruments] setOn:YES];
		[[[[theController pSetup] whichCats] switchFoodDrink] setOn:YES];
		[[[[theController pSetup] whichCats] switchVehicles] setOn:YES];
	}
	
	randCat = rand() % [theCats count];

	if ([[theCats objectAtIndex:randCat] length] > 1) {
		perLib = [[owner imageLibraries] objectAtIndex:[[theCats objectAtIndex:randCat] integerValue]];
		perLex = [[owner wordLibraries] objectAtIndex:[[theCats objectAtIndex:randCat] integerValue]];
		numToGuess = [perLib count];
	} else {
		numToGuess = NUM_PIC;
	}
	
	/*
	 Randomise the timer, and select the pictures for the 4 buttons. Make sure that none of the picture are duplicated.
	 Then choose which button is the correct picture.
	 */
    srand((unsigned int)time(NULL));
	
	btn1 = rand() % numToGuess + 1;
	
	btn2 = btn1;
	while (btn1==btn2) {
		btn2 = rand() % numToGuess + 1;
	}
	
	btn3 = btn1;
	while ((btn1==btn3)||(btn2==btn3)) {
		btn3 = rand() % numToGuess + 1;
	}
	
	btn4 = btn1;
	while ((btn1==btn4)||(btn2==btn4)||(btn3==btn4)) {
		btn4 = rand() % numToGuess + 1;
	}
	
	if ([[theCats objectAtIndex:randCat] length] > 1) {
		[retSet addObject:[perLib objectAtIndex:(btn1 - 1)]];
		[retSet addObject:[perLib objectAtIndex:(btn2 - 1)]];
		[retSet addObject:[perLib objectAtIndex:(btn3 - 1)]];
		[retSet addObject:[perLib objectAtIndex:(btn4 - 1)]];
		switch (correctPic) {
			case 1:
				correctWord = [[NSUserDefaults standardUserDefaults] stringForKey:[perLex objectAtIndex:(btn1 - 1)]];
				break;
			case 2:
				correctWord = [[NSUserDefaults standardUserDefaults] stringForKey:[perLex objectAtIndex:(btn2 - 1)]];
				break;
			case 3:
				correctWord = [[NSUserDefaults standardUserDefaults] stringForKey:[perLex objectAtIndex:(btn3 - 1)]];
				break;
			case 4:
				correctWord = [[NSUserDefaults standardUserDefaults] stringForKey:[perLex objectAtIndex:(btn4 - 1)]];
				break;
			default:
				correctWord = nil;
		}
	} else {
		[retSet addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString
															   stringWithFormat:@"%@%02ld",[theCats objectAtIndex:randCat],(long)btn1]
								  ofType:@"jpg"]]];
		[retSet addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString
																								   stringWithFormat:@"%@%02ld",[theCats objectAtIndex:randCat],(long)btn2]
																						   ofType:@"jpg"]]];
		[retSet addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString
																								   stringWithFormat:@"%@%02ld",[theCats objectAtIndex:randCat],(long)btn3]
																						   ofType:@"jpg"]]];
		[retSet addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString
																								   stringWithFormat:@"%@%02ld",[theCats objectAtIndex:randCat],(long)btn4]
																						   ofType:@"jpg"]]];
		
		NSMutableArray *useWordLib;
		useWordLib = [wordLibraries objectAtIndex:[[theCats objectAtIndex:randCat] integerValue]];
		switch (correctPic) {
			case 1:
				correctWord = [useWordLib objectAtIndex:(btn1 - 1)];
				break;
			case 2:
				correctWord = [useWordLib objectAtIndex:(btn2 - 1)];
				break;
			case 3:
				correctWord = [useWordLib objectAtIndex:(btn3 - 1)];
				break;
			case 4:
				correctWord = [useWordLib objectAtIndex:(btn4 - 1)];
				break;
			default:
				correctWord = nil;
				break;
		}
	}
	return retSet;
}

-(float) randStartX {
	float offsetX = (rand() % 300) + 1;
	if (rand() % 2 + 1 == 2) {
		return -1 * offsetX;
	}
	return 1024 + offsetX;
}

-(float) randStartY {
	float offsetY = (rand() % 300) + 1;
	if (rand() % 2 + 1 == 2) {
		return -1 * offsetY;
	}
	return 768 + offsetY;
}

-(void)playImpact1 {
	NSError *error;
	NSString *pathLoop;
	
	currentTune=TUNE_NONE;
	pathLoop = [[NSBundle mainBundle] pathForResource:@"impact1" ofType:@"mp3"];
	impactPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathLoop] error:nil];
	[impactPlayer1 play];
	if (error) {
		NSLog(@"playImpact, impact1: %@",[error localizedDescription]);
	}
}

-(void)playImpact2 {
	NSError *error;
	NSString *pathLoop;
	
	currentTune=TUNE_NONE;
	pathLoop = [[NSBundle mainBundle] pathForResource:@"impact2" ofType:@"mp3"];
	impactPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathLoop] error:nil];
	[impactPlayer2 play];
	if (error) {
		NSLog(@"playImpact, impact2: %@",[error localizedDescription]);
	}
}

-(void)playImpact3 {
	NSError *error;
	NSString *pathLoop;
	
	currentTune=TUNE_NONE;
	pathLoop = [[NSBundle mainBundle] pathForResource:@"impact3" ofType:@"mp3"];
	impactPlayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathLoop] error:nil];
	[impactPlayer3 play];
	if (error) {
		NSLog(@"playImpact, impact3: %@",[error localizedDescription]);
	}
}

-(void)playImpact4 {
	NSError *error;
	NSString *pathLoop;
	
	currentTune=TUNE_NONE;
	pathLoop = [[NSBundle mainBundle] pathForResource:@"impact4" ofType:@"mp3"];
	impactPlayer4 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathLoop] error:nil];
	[impactPlayer4 play];
	if (error) {
		NSLog(@"playImpact, impact4: %@",[error localizedDescription]);
	}
}

- (void) buildWordLibraries {
	NSMutableArray *wordAnimals,
	*wordInstruments,
	*wordFood,
	*wordVehicles;
	
	wordLibraries = [NSMutableArray arrayWithObjects:nil count:0];
	wordAnimals = [NSMutableArray arrayWithObjects:nil count:0];
	wordInstruments = [NSMutableArray arrayWithObjects:nil count:0];
	wordFood = [NSMutableArray arrayWithObjects:nil count:0];
	wordVehicles = [NSMutableArray arrayWithObjects:nil count:0];
	
	[wordAnimals addObject:@"Dog"];
	[wordAnimals addObject:@"Tiger"];
	[wordAnimals addObject:@"Cat"];
	[wordAnimals addObject:@"Monkey"];
	[wordAnimals addObject:@"Bird"];
	[wordAnimals addObject:@"Elephant"];
	[wordAnimals addObject:@"Fish"];
	[wordAnimals addObject:@"Giraffe"];
	[wordAnimals addObject:@"Horse"];
	[wordAnimals addObject:@"Bear"];
	[wordAnimals addObject:@"Snake"];
	[wordAnimals addObject:@"Turtle"];
	[wordAnimals addObject:@"Camel"];
	[wordAnimals addObject:@"Pig"];
	[wordAnimals addObject:@"Cow"];
	[wordAnimals addObject:@"Goat"];
	[wordAnimals addObject:@"Polar Bear"];
	[wordAnimals addObject:@"Mouse"];
	[wordAnimals addObject:@"Rabbit"];
	[wordAnimals addObject:@"Dolphin"];
	
	[wordInstruments addObject:@"Guitar"];
	[wordInstruments addObject:@"Drum"];
	[wordInstruments addObject:@"Trumpet"];
	[wordInstruments addObject:@"Piano"];
	[wordInstruments addObject:@"Banjo"];
	[wordInstruments addObject:@"Accordion"];
	[wordInstruments addObject:@"Double Bass"];
	[wordInstruments addObject:@"Violin"];
	[wordInstruments addObject:@"Harmonica"];
	[wordInstruments addObject:@"Bell"];
	[wordInstruments addObject:@"Drum"];
	[wordInstruments addObject:@"Saxaphone"];
	[wordInstruments addObject:@"Xylophone"];
	[wordInstruments addObject:@"Penny Whistle"];
	[wordInstruments addObject:@"Shaker"];
	[wordInstruments addObject:@"Pipes"];
	[wordInstruments addObject:@"Kazoo"];
	[wordInstruments addObject:@"Drum Sticks"];
	[wordInstruments addObject:@"Electric Guitar"];
	[wordInstruments addObject:@"Microphone"];
	
	[wordFood addObject:@"Apples"];
	[wordFood addObject:@"Grapes"];
	[wordFood addObject:@"Strawberry"];
	[wordFood addObject:@"Bananas"];
	[wordFood addObject:@"Hot Cross Buns"];
	[wordFood addObject:@"Cake"];
	[wordFood addObject:@"Cherries"];
	[wordFood addObject:@"Sausages"];
	[wordFood addObject:@"Burger"];
	[wordFood addObject:@"Tomato"];
	[wordFood addObject:@"Lollipop"];
	[wordFood addObject:@"Chips"];
	[wordFood addObject:@"Melon"];
	[wordFood addObject:@"Cooked breakfast"];
	[wordFood addObject:@"Crisps"];
	[wordFood addObject:@"Pears"];
	[wordFood addObject:@"Eggs"];
	[wordFood addObject:@"Bread"];
	[wordFood addObject:@"Pizza"];
	[wordFood addObject:@"Broccoli"];
	
	[wordVehicles addObject:@"Car"];
	[wordVehicles addObject:@"Van"];
	[wordVehicles addObject:@"Planes"];
	[wordVehicles addObject:@"Truck"];
	[wordVehicles addObject:@"Motorbike"];
	[wordVehicles addObject:@"Bicycle"];
	[wordVehicles addObject:@"Helicopter"];
	[wordVehicles addObject:@"Train"];
	[wordVehicles addObject:@"Coach"];
	[wordVehicles addObject:@"Trike"];
	[wordVehicles addObject:@"Boat"];
	[wordVehicles addObject:@"Quad bike"];
	[wordVehicles addObject:@"Four by four"];
	[wordVehicles addObject:@"Steam train"];
	[wordVehicles addObject:@"Car"];
	[wordVehicles addObject:@"Boat"];
	[wordVehicles addObject:@"Balloon"];
	[wordVehicles addObject:@"Plane"];
	[wordVehicles addObject:@"Car"];
	[wordVehicles addObject:@"Tram"];
	
	
	[wordLibraries addObject:wordAnimals];
	[wordLibraries addObject:wordInstruments];
	[wordLibraries addObject:wordFood];
	[wordLibraries addObject:wordVehicles];
}

- (void) sayTheWord {
	AVSpeechUtterance *vocaliseWord;
	AVSpeechSynthesizer *theSynth;

	if([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseAnnounce"]) {
		if (correctWord != nil) {
			theSynth = [[AVSpeechSynthesizer alloc] init];
			vocaliseWord = [[AVSpeechUtterance alloc] initWithString:correctWord];
//			vocaliseWord.rate = AVSpeechUtteranceMinimumSpeechRate;
//			vocaliseWord.pitchMultiplier = 1.5;
//			vocaliseWord.preUtteranceDelay = 0.5;
			vocaliseWord.rate = 0.5;
			vocaliseWord.pitchMultiplier = 1.0;
			vocaliseWord.preUtteranceDelay = 0.5;
			vocaliseWord.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-AU"];
			[theSynth speakUtterance:vocaliseWord];
		}
    }
}

- (void) successRoutine {
	UIImageView *aPic;
	
	if (iTimer) {
		[iTimer invalidate];
	}
	
	if (pTimer) {
		[pTimer invalidate];
	}
	
	if (vTimer) {
		[vTimer invalidate];
	}
	
	/*
	 Store the starting position of the button, to be used in when the Well Done audio has finished.
	 */
	buttonReturn = theButton.frame.origin.x;
	
	/*
	 Now hide the 3 incorrect images.
	 */
	for (int pIdx=0; pIdx < [thePics count]; pIdx++) {
		aPic=[thePics objectAtIndex:pIdx];
		
		[aPic setImage:nil];
	}
	
	if (hLight != nil) {
		[hLight setHidden:YES];
	}
	
	if (hCLight != nil) {
		[hCLight setHidden:YES];
	}
	
	/*
	 Set the audio file to congratulations & start playing it.
	 Set the current tune, so that the audioPlayerDidFinishPlaying method can track progress.
	 */
	NSString *pathCongratulations;
    pathCongratulations = [[NSBundle mainBundle] pathForResource:[successTunes objectAtIndex:(rand() % 5)]
														  ofType:@"mp3"];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathCongratulations] error:nil];
	[avPlayer play];
	[avPlayer setDelegate:owner];
	
	currentTune = TUNE_CONG_1;
	
	[theButton setEnabled:NO];
	[theButton setAdjustsImageWhenDisabled:NO];
	/*
	 Now animate the button to move to the center of the screen, and animate the top half of the screen to turn green
	 */
	[UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [theButton setFrame:CGRectMake(BC_X,BN_Y,BN_S, BN_S)];
     }
                     completion:^(BOOL finished)
     {
     }];

	[UIView animateWithDuration:2.0
                          delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^(void)
     {
         topScreen.backgroundColor = [UIColor greenColor];
     }
                     completion:^(BOOL finished)
     {
     }];

}
@end
