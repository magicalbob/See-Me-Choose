//
//  ViewController.h
//  See Me Choose
//
//  Created by Ian on 10/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "pageSetup.h"
#import "pageGame.h"

@interface ViewController : UIViewController
<AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	float scaleX;
	float scaleY;
	NSMutableArray *successTunes;
}
@property float scaleX;
@property float scaleY;
@property pageSetup *pSetup;
@property pageGame *pGame;
@property NSMutableArray *imageLibraries;
@property NSMutableArray *wordLibraries;
- (void) buildImageLibraries;
@end
