//
//  editAlbum.h
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photoChoice.h"

@interface editAlbum : UIView {
	UIView *view;
	id albumController;
	id vCont;
	UIView *backgroundPanel;
	NSString *albumName;
	NSInteger albumNo;
	UIButton *uiDone;
}

- (id)initWithFrame:(CGRect)frame
			  vCont:(id)vVCont
	  containerView:(UIView *)containerView
	albumController:(id)vAlbumController
		  albumName:(NSString *)vAlbumName
			albumNo:(NSInteger)vAlbumNo;
@end
