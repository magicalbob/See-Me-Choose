//
//  selectMessages.h
//  See Me Choose
//
//  Created by Ian on 13/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "messageRecorder.h"

@interface selectMessages : NSObject {
	messageRecorder *msgRec1;
	messageRecorder *msgRec2;
	messageRecorder *msgRec3;
	messageRecorder *msgRec4;
	UIView *view;
	UIView *panelMess;
}
- (id) init:(UIView *)containerView;
- (void) disableAllButtons;
@property UIView *view;
@end
