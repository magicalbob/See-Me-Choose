//
//  selectImages.m
//  See Me Choose
//
//  Created by Ian on 13/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "selectImages.h"

@implementation selectImages
- (id) init:(UIView *)containerView vCont:(id)vVCont {
	self = [super init];
	
	if (self) {
		self.view=containerView;
		vCont = vVCont;
		[self displayImages];
		
	}
	
	return self;
}

- (void) displayImages {
	// Display the background panel for choosing categories
	
	UIView *panelImage;
	
	panelImage = [[UIView alloc] initWithFrame:CGRectMake(86, 362, 500, 267)];
	panelImage.backgroundColor = [UIColor yellowColor];
	[self.view addSubview:panelImage];
	[self.view bringSubviewToFront:panelImage];
	
	UIImageView *frameImage;
	
	frameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 267)];
	frameImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frameBig" ofType:@"png"]];
	[panelImage addSubview:frameImage];
	[panelImage bringSubviewToFront:frameImage];
	
	album1 = [[imageSelect alloc] initWithFrame:CGRectMake(30, 38, 440, 36) owner:self vCont:vCont containerView:panelImage labelDefault:@"Personal album 1" albumNo:1];
	
	album2 = [[imageSelect alloc] initWithFrame:CGRectMake(30, 90, 440, 36) owner:self vCont:vCont containerView:panelImage labelDefault:@"Personal album 2" albumNo:2];
	
	album3 = [[imageSelect alloc] initWithFrame:CGRectMake(30, 142, 440, 36) owner:self vCont:vCont containerView:panelImage labelDefault:@"Personal album 3" albumNo:3];
	
	album4 = [[imageSelect alloc] initWithFrame:CGRectMake(30, 194, 440, 36) owner:self vCont:vCont containerView:panelImage labelDefault:@"Personal album 4" albumNo:4];
}
@end
