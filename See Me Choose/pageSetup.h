//
//  pageSetup.h
//  See Me Choose
//
//  Created by Ian on 11/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "selectCats.h"
#import "selectMessages.h"
#import "selectImages.h"
#import "selectAids.h"

@interface pageSetup : NSObject {
	UIView *view;
	UIView *wholeScreen;
	selectCats *whichCats;
	selectMessages *whichMessages;
	selectImages *whichImages;
	selectAids *whichAids;
	id vCont;
	@public UIButton *goButton;
}
- (id) init:(UIView *)containerView vCont:(id)vVCont;
- (void) resumeSetup;
@property selectCats *whichCats;
@property selectMessages *whichMessages;
@property selectImages *whichImages;
@property selectAids *whichAids;
@end
