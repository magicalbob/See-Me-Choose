//
//  selectCats.h
//  See Me Choose
//
//  Created by Ian on 11/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selectCats : NSObject {
	UIView *view;
	UISwitch *switchAnimals;
	UISwitch *switchFoodDrink;
	UISwitch *switchInstruments;
	UISwitch *switchVehicles;
}
- (id) init:(UIView *)containerView;
@property UISwitch *switchAnimals;
@property UISwitch *switchFoodDrink;
@property UISwitch *switchInstruments;
@property UISwitch *switchVehicles;
@end
