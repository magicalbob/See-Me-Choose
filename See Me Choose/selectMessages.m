//
//  selectMessages.m
//  See Me Choose
//
//  Created by Ian on 13/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "selectMessages.h"

@implementation selectMessages

@synthesize view;
- (id) init:(UIView *)containerView {
	self = [super init];
	
	if (self) {
		view=containerView;
		[self displayMessages];
	}
	
	return self;
}

- (void) displayMessages {
	// Display the background panel for choosing categories
	
	panelMess = [[UIView alloc] initWithFrame:CGRectMake(441, 78, 500, 267)];
	panelMess.backgroundColor = [UIColor yellowColor];
	[view addSubview:panelMess];
	[view bringSubviewToFront:panelMess];
	
	UIImageView *frameMess;
	
	frameMess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 267)];
	frameMess.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frameBig" ofType:@"png"]];
	[panelMess addSubview:frameMess];
	[panelMess bringSubviewToFront:frameMess];
	
	// Add 4 personal messages, with text field for name and a record, play & delete button.

	msgRec1 = [[messageRecorder alloc] initWithFrame:CGRectMake(30, 38, 440, 36)
											   owner:self containerView:panelMess
										labelDefault:@"Personal success message 1"
										   labelName:@"seeMeChooseMsgName1"
										 messageName:@"seeMeChooseMessage1"];

	msgRec2 = [[messageRecorder alloc] initWithFrame:CGRectMake(30, 90, 440, 36)
											   owner:self containerView:panelMess
										labelDefault:@"Personal success message 2"
										   labelName:@"seeMeChooseMsgName2"
										 messageName:@"seeMeChooseMessage2"];
	
	msgRec3 = [[messageRecorder alloc] initWithFrame:CGRectMake(30, 142, 440, 36)
											   owner:self containerView:panelMess
										labelDefault:@"Personal success message 3"
										   labelName:@"seeMeChooseMsgName3"
										 messageName:@"seeMeChooseMessage3"];
	
	msgRec4 = [[messageRecorder alloc] initWithFrame:CGRectMake(30, 194, 440, 36)
											   owner:self containerView:panelMess
										labelDefault:@"Personal success message 4"
										   labelName:@"seeMeChooseMsgName4"
										 messageName:@"seeMeChooseMessage4"];
	
}

- (void) disableAllButtons {
	[msgRec1.uiRecord setEnabled:NO];
	[msgRec1.uiPlay setEnabled:NO];
	[msgRec1.uiDelete setEnabled:NO];
	[msgRec2.uiRecord setEnabled:NO];
	[msgRec2.uiPlay setEnabled:NO];
	[msgRec2.uiDelete setEnabled:NO];
	[msgRec3.uiRecord setEnabled:NO];
	[msgRec3.uiPlay setEnabled:NO];
	[msgRec3.uiDelete setEnabled:NO];
	[msgRec4.uiRecord setEnabled:NO];
	[msgRec4.uiPlay setEnabled:NO];
	[msgRec4.uiDelete setEnabled:NO];
}

- (void) enableAllButtons {
	[msgRec1 enableAllButtons];
	[msgRec2 enableAllButtons];
	[msgRec3 enableAllButtons];
	[msgRec4 enableAllButtons];
}



@end
