//
//  photoChoice.m
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "photoChoice.h"
#import "imageSelect.h"
#import "ViewController.h"

@implementation photoChoice

@synthesize photoLibrary;

- (id)initWithFrame:(CGRect)frame
			  vCont:(id)vVCont
	  containerView:(UIView *)containerView
	albumController:(id)vAlbumController
		  photoName:(NSString *)vPhotoName
		  titleName:(NSString *)vTitleName
		   photoNum:(NSInteger)vPhotoNum
{
    self = [super initWithFrame:frame];
    if (self) {
		view = containerView;
		mySelf = self;
		photoName = vPhotoName;
		photoNum = vPhotoNum;
		titleName = vTitleName;
		albumController = vAlbumController;
		vCont = vVCont;
		defaultTitle = NO;
		assetsLibrary = [[ALAssetsLibrary alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		
		[self displayPanel];
    }
    return self;
}

- (void) displayPanel {
	panelPic = [[UIImageView alloc] initWithFrame:self.frame];
	panelPic.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picBack" ofType:@"png"]];
	[view addSubview:panelPic];
	[view bringSubviewToFront:panelPic];
	[panelPic setUserInteractionEnabled:YES];
	
	uiAdd = [[UIButton alloc] initWithFrame:CGRectMake(135, 60, 30, 30)];
	[uiAdd setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addButton" ofType:@"png"]] forState:UIControlStateNormal];
	[panelPic addSubview:uiAdd];
	[panelPic bringSubviewToFront:uiAdd];
	
	uiDel = [[UIButton alloc] initWithFrame:CGRectMake(135, 110, 30, 30)];
	[uiDel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"subButton" ofType:@"png"]] forState:UIControlStateNormal];
	[panelPic addSubview:uiDel];
	[panelPic bringSubviewToFront:uiDel];
	[uiDel setHidden:YES];
	
	uiTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 160, 28)];
	uiTitle.text = [[NSUserDefaults standardUserDefaults] stringForKey:titleName];
	if ([uiTitle.text length] == 0) {
		uiTitle.text = @"Picture name?";
		defaultTitle = YES;
	}
	uiTitle.backgroundColor = [UIColor yellowColor];
	[panelPic addSubview:uiTitle];
	[panelPic bringSubviewToFront:uiTitle];
	[uiTitle setEnabled:NO];
	
	[uiAdd addTarget:mySelf action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
	[uiDel addTarget:mySelf action:@selector(delPhoto) forControlEvents:UIControlEventTouchUpInside];
	
	picImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 100, 100)];
	picImage.backgroundColor = [UIColor colorWithRed:0.7 green:0.9 blue:0.7 alpha:1.0];
	[panelPic addSubview:picImage];
	[panelPic bringSubviewToFront:picImage];
	NSURL *testURL = [[NSUserDefaults standardUserDefaults] URLForKey:photoName];
	if (testURL == NULL) {
		uiTitle.text = @"";
	} else {
		[assetsLibrary assetForURL:testURL resultBlock: ^(ALAsset *asset){
			
            CGImageRef imageRef;
            
            imageRef = [asset thumbnail];
            if (imageRef) {
                [picImage setImage:[UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp]];
				[uiDel setHidden:NO];
				[uiTitle setEnabled:YES];
            }
        } failureBlock:^(NSError *error) {
            // Handle failure.
        }];
	}
}

- (void) addPhoto {	
	maskPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	maskPanel.backgroundColor = [UIColor whiteColor];
	[view addSubview:maskPanel];
	[view bringSubviewToFront:maskPanel];
	
	photoLibrary = [[UIImagePickerController alloc] init];
	photoLibrary.modalPresentationStyle = UIModalPresentationCurrentContext;
	photoLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	photoLibrary.delegate = self;
	[maskPanel addSubview:photoLibrary.view];
	[maskPanel bringSubviewToFront:photoLibrary.view];
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"usePortrait"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"usePortrait"];
	[photoLibrary dismissViewControllerAnimated:YES completion:NULL];
	[maskPanel removeFromSuperview];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *testURL = [info valueForKey:UIImagePickerControllerReferenceURL];

    [assetsLibrary assetForURL:testURL resultBlock: ^(ALAsset *asset){
			CGImageRef imageRef = [asset thumbnail];
			if (imageRef) {
				picImage.image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
				[uiDel setHidden:NO];
				[uiTitle setEnabled:YES];
				// Store URL of selected picture in user defaults
				[[NSUserDefaults standardUserDefaults] setURL:testURL forKey:photoName];
				[vCont buildImageLibraries];
			}
		} failureBlock:^(NSError *error) {
        // Handle failure.
    }];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"usePortrait"];
	[albumController setAlbumEnabler:photoNum];
	[photoLibrary dismissViewControllerAnimated:YES completion:NULL];
	[maskPanel removeFromSuperview];
}
	 
- (void) delPhoto {
	[picImage setImage:nil];
	[uiDel setHidden:YES];
	[uiTitle setEnabled:NO];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:photoName];
	[albumController setAlbumEnabler];
	[vCont buildImageLibraries];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if ([uiTitle isFirstResponder]) {
		savePosition = [panelPic frame];
		maskView = [[UIView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
		maskView.backgroundColor = [UIColor greenColor];
		[view addSubview:maskView];
		if (defaultTitle) {
			uiTitle.text = @"";
		}
		[UIView animateWithDuration:0.2
							  delay:0
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^(void)
		 {
			 [panelPic setFrame:CGRectMake(512 - (panelPic.frame.size.width / 2), 75, panelPic.frame.size.width, panelPic.frame.size.height)];
		 }
						 completion:^(BOOL finished)
		 {
		 }];
		[view bringSubviewToFront:panelPic];
		[uiAdd setEnabled:NO];
		[uiDel setEnabled:NO];
	}
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([panelPic window]) {
		if (savePosition.origin.x > 0) {
			[UIView animateWithDuration:0.2
								  delay:0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^(void)
			 {
				 [panelPic setFrame:savePosition];
			 }
							 completion:^(BOOL finished)
			 {
				 [maskView removeFromSuperview];

			 }];
			[uiAdd setEnabled:YES];
			[uiDel setEnabled:YES];
		}
		if ([uiTitle.text length] > 0 ) {
			if (![uiTitle.text isEqualToString:@"Picture name?"]) {
				[[NSUserDefaults standardUserDefaults] setObject:uiTitle.text forKey:titleName];
			}
		}
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
