//
//  messageRecorder.m
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "messageRecorder.h"
#import "selectMessages.h"

@implementation messageRecorder

- (id)initWithFrame:(CGRect)frame
			  owner:(id)vOwner
	  containerView:(UIView *)containerView
	   labelDefault:(NSString *)vLabelDefault
		  labelName:(NSString *)vLabelName
		messageName:(NSString *)vMessageName
{
    self = [super initWithFrame:frame];
    if (self) {
        labelDefault = vLabelDefault;
		labelName = vLabelName;
		messageName = vMessageName;
		contView = containerView;
		mySelf = self;
		owner = vOwner;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		
		[self displayPanel];
    }
    return self;
}

- (void) displayPanel
{
	panelRec = [[UIView alloc] initWithFrame:self.frame];
	[contView addSubview:panelRec];
	[contView bringSubviewToFront:panelRec];
	
	uiMessage = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, self.frame.size.height)];
	NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:labelName];
	if (savedName == nil) {
		uiMessage.text = labelDefault;
	} else {
		uiMessage.text = savedName;
	}

	[panelRec addSubview:uiMessage];
	[panelRec bringSubviewToFront:uiMessage];
	
	self.uiRecord = [[UIButton alloc] initWithFrame:CGRectMake(240, 3, 30, 30)];
	[self.uiRecord setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recButton" ofType:@"png"] ] forState:UIControlStateNormal];
	[panelRec addSubview:self.uiRecord];
	[panelRec bringSubviewToFront:self.uiRecord];
	
	self.uiPlay = [[UIButton alloc] initWithFrame:CGRectMake(321, 3, 30, 30)];
	[self.uiPlay setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playButton" ofType:@"png"] ] forState:UIControlStateNormal];
	[panelRec addSubview:self.uiPlay];
	[panelRec bringSubviewToFront:self.uiPlay];
	
	self.uiDelete = [[UIButton alloc] initWithFrame:CGRectMake(402, 3, 30, 30)];
	[self.uiDelete setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"subButton" ofType:@"png"] ] forState:UIControlStateNormal];
	[panelRec addSubview:self.uiDelete];
	[panelRec bringSubviewToFront:self.uiDelete];
	
	//Load recording path from preferences
	[self enableAllButtons];
	
	[self.uiRecord addTarget:self action:@selector(buttonRecord) forControlEvents:UIControlEventTouchUpInside];
	[self.uiPlay addTarget:self action:@selector(buttonPlay) forControlEvents:UIControlEventTouchUpInside];
	[self.uiDelete addTarget:self action:@selector(buttonDelete) forControlEvents:UIControlEventTouchUpInside];
}

- (void) buttonRecord {
    //Save recording path to preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"%@.m4a", messageName],
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    [prefs setURL:outputFileURL forKey:messageName];
    [prefs synchronize];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    avRec = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    avRec.delegate = mySelf;
    avRec.meteringEnabled = YES;
    [avRec prepareToRecord];
    
    [session setActive:YES error:nil];
    
    // Disable buttons so that recording can finish uninterrupted
	[owner disableAllButtons];
    
    // Animation to give feedback on how long the recorder has got to run
	UIView *recordMain, *recordProgress, *recordRecord;
	recordMain=[[UIView alloc] initWithFrame:CGRectMake(240, 0, 200, 36)];
	recordMain.backgroundColor = [UIColor redColor];
	[panelRec addSubview:recordMain];
	[panelRec bringSubviewToFront:recordMain];
	
	recordRecord=[[UIView alloc] initWithFrame:CGRectMake(240, 0, 200, 36)];
	recordRecord.backgroundColor = [UIColor blueColor];
	[panelRec addSubview:recordRecord];
	[panelRec bringSubviewToFront:recordRecord];
	
	recordProgress=[[UIView alloc] initWithFrame:CGRectMake(240, 0, 200, 36)];
	recordProgress.backgroundColor = [UIColor yellowColor];
	[panelRec addSubview:recordProgress];
	[panelRec bringSubviewToFront:recordProgress];
    
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [recordProgress setFrame:CGRectMake(440, 0, 0, 36)];
     }
                     completion:^(BOOL finished)
     {
         [recordMain setHidden:YES];
         [recordProgress setHidden:YES];
         [recordRecord setHidden:YES];
     }];
    
    // Start recording
    [avRec recordForDuration:4];
}

- (void) buttonPlay
{
    NSURL *temporaryRecFile;
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    temporaryRecFile = [prefs URLForKey:messageName];
	avPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
    [avPlay setDelegate:mySelf];
    [avPlay play];
    
	[owner disableAllButtons];
	
    // Animation to give feedback on how long the recorder has got to run
	UIView *recordMain, *recordProgress, *recordRecord;
	recordMain=[[UIView alloc] initWithFrame:CGRectMake(240, 0, 200, 36)];
	recordMain.backgroundColor = [UIColor redColor];
	[panelRec addSubview:recordMain];
	[panelRec bringSubviewToFront:recordMain];
	
	recordRecord=[[UIView alloc] initWithFrame:CGRectMake(240, 0, 200, 36)];
	recordRecord.backgroundColor = [UIColor blueColor];
	[panelRec addSubview:recordRecord];
	[panelRec bringSubviewToFront:recordRecord];
	
	recordProgress=[[UIView alloc] initWithFrame:CGRectMake(240, 0, 200, 36)];
	recordProgress.backgroundColor = [UIColor yellowColor];
	[panelRec addSubview:recordProgress];
	[panelRec bringSubviewToFront:recordProgress];
    
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [recordProgress setFrame:CGRectMake(440, 0, 0, 36)];
     }
                     completion:^(BOOL finished)
     {
         [recordMain setHidden:YES];
         [recordProgress setHidden:YES];
         [recordRecord setHidden:YES];
     }];
}

- (void) buttonDelete {
	//Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs removeObjectForKey:messageName];
	
	[self enableAllButtons];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[owner enableAllButtons];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
	[owner enableAllButtons];
}

- (void) enableAllButtons {
	//Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
    if ([prefs URLForKey:messageName]!=NULL) {
        [self.uiPlay setEnabled:YES];
        [self.uiDelete setEnabled:YES];
    } else {
        [self.uiPlay setEnabled:NO];
        [self.uiDelete setEnabled:NO];
    }
	
	[self.uiRecord setEnabled:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if ([uiMessage isFirstResponder]) {
		savePosition = [contView frame];
		maskView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
		maskView.backgroundColor = [UIColor greenColor];
		[[owner view] addSubview:maskView];
		[[owner view] bringSubviewToFront:maskView];
		[[owner view] bringSubviewToFront:contView];
		[UIView animateWithDuration:0.2
							  delay:0
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^(void)
		 {
			 [contView setFrame:CGRectMake(262, 75, contView.frame.size.width, contView.frame.size.height)];
		 }
						 completion:^(BOOL finished)
		 {
		 }];
	}
}

static inline BOOL IsEmpty(id thing) {
	return thing == nil
	|| ([thing respondsToSelector:@selector(length)]
		&& [(NSData *)thing length] == 0)
	|| ([thing respondsToSelector:@selector(count)]
		&& [(NSArray *)thing count] == 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([contView window]) {
		if (savePosition.origin.x > 0) {
			[UIView animateWithDuration:0.2
								  delay:0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
			 {
				 [contView setFrame:savePosition];
			 }
							 completion:^(BOOL finished)
			 {
				 [maskView removeFromSuperview];
			 }];
		}
		if (IsEmpty([uiMessage text])) {
			uiMessage.text = labelDefault;
		}

		[[NSUserDefaults standardUserDefaults] setObject:uiMessage.text forKey:labelName];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
