//
//  messageRecorder.h
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface messageRecorder : UIView {
	UIView *contView;
	NSString *labelDefault;
	NSString *messageName;
	UIView *panelRec;
	UITextField *uiMessage;
	NSString *labelName;
	AVAudioRecorder *avRec;
	AVAudioPlayer *avPlay;
	CGRect savePosition;
	UIView *maskView;
	int keyboardShowing;
	id mySelf;
	id owner;
}

- (id)initWithFrame:(CGRect)frame owner:(id)vOwner containerView:(UIView *)containerView labelDefault:(NSString *)vLabelDefault labelName:(NSString *)vLabelName messageName:(NSString *)vMessageName;
- (void) enableAllButtons;
@property UIButton *uiRecord;
@property UIButton *uiPlay;
@property UIButton *uiDelete;
@end
