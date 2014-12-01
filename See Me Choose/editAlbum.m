//
//  editAlbum.m
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "editAlbum.h"

@implementation editAlbum

- (id)initWithFrame:(CGRect)frame
			  vCont:(id)vVCont
	  containerView:(UIView *)containerView
	albumController:(id)vAlbumController
		  albumName:(NSString *)vAlbumName
			albumNo:(NSInteger)vAlbumNo
{
    self = [super initWithFrame:frame];
    if (self) {
		view = containerView;
		albumName = vAlbumName;
		albumNo = vAlbumNo;
		albumController = vAlbumController;
		vCont = vVCont;
		[self displayPanel];
    }
    return self;
}

- (void) displayPanel {
	backgroundPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	backgroundPanel.backgroundColor = [UIColor greenColor];
	[view addSubview:backgroundPanel];
	[view bringSubviewToFront:backgroundPanel];

	UILabel *albumTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
	CGSize labSize = [albumName sizeWithAttributes:@{NSFontAttributeName:[albumTitle font]}];
	[albumTitle setFrame:CGRectMake(512 - (labSize.width/2), 35, labSize.width, labSize.height)];
	albumTitle.text = albumName;
	[backgroundPanel addSubview:albumTitle];
	[backgroundPanel bringSubviewToFront:albumTitle];
	
	uiDone = [[UIButton alloc] initWithFrame:CGRectMake(934, 22, 50, 50)];
	[uiDone setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"doneButton" ofType:@"png"]] forState:UIControlStateNormal];
	[backgroundPanel addSubview:uiDone];
	[backgroundPanel bringSubviewToFront:uiDone];
	[uiDone addTarget:self action:@selector(doneEdit) forControlEvents:UIControlEventTouchUpInside];
	
	for (int pIdx=0; pIdx < 20; pIdx++) {
		CGRect photoFrame = CGRectMake((float)((pIdx % 5) * 200) + 22, (float)((pIdx % 4) * 169) + 84, (float) 180, (float) 160);
		photoChoice *aPhoto __unused = [[photoChoice alloc] initWithFrame:photoFrame
														   vCont:vCont containerView:backgroundPanel
												 albumController:albumController
													   photoName:[NSString stringWithFormat:@"album%ldPic%d",(long)albumNo,pIdx+1]
													   titleName:[NSString stringWithFormat:@"seeMeChooseTitle%ldPic%d",(long)albumNo,pIdx+1]
														photoNum:pIdx+1];
	}
}

- (void) doneEdit {
	[backgroundPanel removeFromSuperview];
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
