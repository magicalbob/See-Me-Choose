//
//  selectAids.h
//  See Me Choose
//
//  Created by Ian on 13/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selectAids : NSObject <UIPickerViewDelegate> {
	UIView *view;
	UISwitch *use2or4;
	UISwitch *useAnnounce;
	UISwitch *useHighlight;
	UILabel *useTime1Label;
	UIPickerView *useTimePicker;
	UILabel *useTime2Label;
}
- (id) init:(UIView *)containerView;
@end
