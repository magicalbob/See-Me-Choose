//
//  selectImages.h
//  See Me Choose
//
//  Created by Ian on 13/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imageSelect.h"

@interface selectImages : NSObject {
	imageSelect *album1;
	imageSelect *album2;
	imageSelect *album3;
	imageSelect *album4;
	id vCont;
}
- (id) init:(UIView *)containerView vCont:(id)vVCont;
@property UIView *view;
@end
