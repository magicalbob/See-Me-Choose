//
//  imageSelect.m
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "imageSelect.h"
#import "selectImages.h"

@implementation imageSelect

- (id)initWithFrame:(CGRect)frame
			  owner:(id)vOwner
			  vCont:(id)vVCont
	  containerView:(UIView *)containerView
	   labelDefault:(NSString *)vLabelDefault
			albumNo:(NSInteger)vAlbumNo
{
    self = [super initWithFrame:frame];
    if (self) {
		labelDefault = vLabelDefault;
		albumNo = vAlbumNo;
		contView = containerView;
		vCont = vVCont;
		mySelf = self;
		owner = vOwner;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		
		[self displayPanel];
    }
    return self;
}

- (void) displayPanel {
	panelRec = [[UIView alloc] initWithFrame:self.frame];
	[contView addSubview:panelRec];
	[contView bringSubviewToFront:panelRec];
	
	uiMessage = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, self.frame.size.height)];
	NSString *savedName = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"seeMeCountAlbum%ld",(long)albumNo]];
	if (savedName == nil) {
		uiMessage.text = labelDefault;
	} else {
		uiMessage.text = savedName;
	}
	[panelRec addSubview:uiMessage];
	[panelRec bringSubviewToFront:uiMessage];
	
	uiEdit = [[UIButton alloc] initWithFrame:CGRectMake(340,0,30,30)];
	[uiEdit setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"setAlbum" ofType:@"png"] ] forState:UIControlStateNormal];
	[panelRec addSubview:uiEdit];
	[panelRec bringSubviewToFront:uiEdit];
	[uiEdit addTarget:self action:@selector(editTheAlbum) forControlEvents:UIControlEventTouchUpInside];
	
	uiEnable = [[UISwitch alloc] initWithFrame:CGRectMake(380, 0, 50, 30)];
	[panelRec addSubview:uiEnable];
	[panelRec bringSubviewToFront:uiEnable];
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"usePersonal%ld",(long)albumNo]]) {
		[uiEnable setOn:YES];
	} else {
		[uiEnable setOn:NO];
	}

	[uiEnable addTarget:self action:@selector(albumHasSwitched) forControlEvents:UIControlEventValueChanged];
	
	[self setAlbumEnabler];
}

- (void) albumHasSwitched {
	if ([uiEnable isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"usePersonal%ld",(long)albumNo]];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"usePersonal%ld",(long)albumNo]];
    }
}

- (void) editTheAlbum {
	uiAlbum = [[editAlbum alloc] initWithFrame:CGRectMake(0,0,1024,768) vCont:vCont containerView:[owner view] albumController:self albumName:uiMessage.text albumNo:albumNo];
}

- (void) setAlbumEnabler {
	if ([self canEnableAlbum:0]) {
		[uiEnable setEnabled:YES];
	} else {
		[uiEnable setEnabled:NO];
	}
}

- (void) setAlbumEnabler:(NSInteger)imageChanged {
	if ([self canEnableAlbum:imageChanged]) {
		[uiEnable setEnabled:YES];
	} else {
		[uiEnable setEnabled:NO];
	}
}

- (BOOL) canEnableAlbum:(NSInteger)imageChanged {
	NSInteger numPicsInAlbum = 0;
	
	for (int pIdx=1; pIdx<=20; pIdx++) {
		NSURL *testURL = [[NSUserDefaults standardUserDefaults] URLForKey:[NSString stringWithFormat:@"album%ldPic%d",(long)albumNo,pIdx]];
		
		if (testURL != NULL) {
			if (pIdx != imageChanged) {
				numPicsInAlbum++;
			}
		} else {
			if (pIdx == imageChanged) {
				numPicsInAlbum++;
			}
		}
	}
	
	if (numPicsInAlbum<4) {
		return NO;
	}
	
	return YES;
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
		[[NSUserDefaults standardUserDefaults] setObject:uiMessage.text forKey:[NSString stringWithFormat:@"seeMeCountAlbum%ld",(long)albumNo]];
			
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
