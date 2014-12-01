//
//  photoChoice.h
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface photoChoice : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIView *view;
	UIView *maskPanel;
	UIImageView *picImage;
	UIButton *uiAdd;
	UIButton *uiDel;
	NSString *photoName;
	NSInteger photoNum;
	NSString *titleName;
	UITextField *uiTitle;
	ALAssetsLibrary *assetsLibrary;
	CGRect savePosition;
	UIView *maskView;
	UIImageView *panelPic;
	BOOL defaultTitle;
	id vCont;
	id mySelf;
	id albumController;
}
- (id)initWithFrame:(CGRect)frame
			  vCont:(id)vVCont
	  containerView:(UIView *)containerView
	albumController:(id)vAlbumController
		  photoName:(NSString *)vPhotoName
		  titleName:(NSString *)vTitleName
		   photoNum:(NSInteger)vPhotoNum;
@property (nonatomic) UIImagePickerController *photoLibrary;
@end
