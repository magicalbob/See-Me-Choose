//
//  imageSelect.h
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "editAlbum.h"

@interface imageSelect : UIView{
	UIView *contView;
	NSString *labelDefault;
	NSInteger albumNo;
	UIView *panelRec;
	UITextField *uiMessage;
	UIButton *uiEdit;
	UISwitch *uiEnable;
	editAlbum *uiAlbum;
	CGRect savePosition;
	UIView *maskView;
	id vCont;
	id mySelf;
	id owner;
}
- (id)initWithFrame:(CGRect)frame owner:(id)vOwner vCont:(id)vVCont containerView:(UIView *)containerView labelDefault:(NSString *)vLabelDefault albumNo:(NSInteger)vAlbumNo;
- (void) setAlbumEnabler;
- (void) setAlbumEnabler:(NSInteger)imageChanged;
@end
