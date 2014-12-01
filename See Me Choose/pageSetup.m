//
//  pageSetup.m
//  See Me Choose
//
//  Created by Ian on 11/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "pageSetup.h"

@implementation pageSetup

@synthesize whichCats;
@synthesize whichMessages;
@synthesize whichImages;
@synthesize whichAids;

- (id) init:(UIView *)containerView vCont:(id)vVCont {
	self = [super init];
	
	if (self) {
		view = containerView;
		vCont = vVCont;
		[self displaySetup];
	}
	
	return self;
}

- (void)displaySetup {
	// Method to display the setup screen
	
	// Add view to cover whole screen and set background to bright green
	wholeScreen = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
	wholeScreen.backgroundColor=[UIColor greenColor];
	[view addSubview:wholeScreen];
	[view bringSubviewToFront:wholeScreen];
	
	// Add panel to select which categories of images should be used
	whichCats = [[selectCats alloc] init:wholeScreen];
	
	// Add panel to allow personal success messages to be recorded
	whichMessages = [[selectMessages alloc] init:wholeScreen];
	
	// Add panel to allow personal image libraries to be selected
	whichImages = [[selectImages alloc] init:wholeScreen vCont:vCont];
	
	// Add panel to allow hints / tips etc to be selected
	whichAids = [[selectAids alloc] init:wholeScreen];
	
	// Add the go button to start the game
	goButton = [[UIButton alloc] initWithFrame:CGRectMake(476, 673, 73, 75)];
	[goButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go" ofType:@"png"]] forState:UIControlStateNormal];
	[wholeScreen addSubview:goButton];
	[wholeScreen bringSubviewToFront:goButton];
}

- (void) resumeSetup {
	[view bringSubviewToFront:wholeScreen];
}
@end
