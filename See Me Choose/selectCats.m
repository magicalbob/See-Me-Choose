//
//  selectCats.m
//  See Me Choose
//
//  Created by Ian on 11/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "selectCats.h"

@implementation selectCats

@synthesize switchAnimals;
@synthesize switchFoodDrink;
@synthesize switchInstruments;
@synthesize switchVehicles;

- (id) init:(UIView *)containerView {
	self = [super init];
	
	if (self) {
		view=containerView;
		[self displayCats];
	}
	
	return self;
}

- (void) displayCats {
	// Display the background panel for choosing categories
	
	UIView *panelCats;
	
	panelCats = [[UIView alloc] initWithFrame:CGRectMake(86, 78, 338, 267)];
	panelCats.backgroundColor = [UIColor yellowColor];
	[view addSubview:panelCats];
	[view bringSubviewToFront:panelCats];
	
	UIImageView *frameCats;
	
	frameCats = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 338, 267)];
	frameCats.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frameSmall" ofType:@"png"]];
	[panelCats addSubview:frameCats];
	[panelCats bringSubviewToFront:frameCats];
	
	// Display the label & switch for each category
	
	UILabel *labAnimals,
	        *labFoodDrink,
			*labInstruments,
			*labVehicles;

	labAnimals = [[UILabel alloc] initWithFrame:CGRectMake(30,38,277,37)];
	labAnimals.text = @"Animals";
	[panelCats addSubview:labAnimals];
	[panelCats bringSubviewToFront:labAnimals];

	labFoodDrink = [[UILabel alloc] initWithFrame:CGRectMake(30,90,277,37)];
	labFoodDrink.text = @"Food and Drink";
	[panelCats addSubview:labFoodDrink];
	[panelCats bringSubviewToFront:labFoodDrink];

	labInstruments = [[UILabel alloc] initWithFrame:CGRectMake(30,142,277,37)];
	labInstruments.text = @"Instruments";
	[panelCats addSubview:labInstruments];
	[panelCats bringSubviewToFront:labInstruments];

	labVehicles = [[UILabel alloc] initWithFrame:CGRectMake(30,194,277,37)];
	labVehicles.text = @"Vehicles";
	[panelCats addSubview:labVehicles];
	[panelCats bringSubviewToFront:labVehicles];
	
	switchAnimals = [[UISwitch alloc] initWithFrame:CGRectMake(250,41,49,31)];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useAnimals"]) {
		[switchAnimals setOn:YES];
	} else {
		[switchAnimals setOn:NO];
	}
	[panelCats addSubview:switchAnimals];
	[panelCats bringSubviewToFront:switchAnimals];

	switchFoodDrink = [[UISwitch alloc] initWithFrame:CGRectMake(250,93,49,31)];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useFood"]) {
		[switchFoodDrink setOn:YES];
	} else {
		[switchFoodDrink setOn:NO];
	}
	[panelCats addSubview:switchFoodDrink];
	[panelCats bringSubviewToFront:switchFoodDrink];
	
	switchInstruments = [[UISwitch alloc] initWithFrame:CGRectMake(250,145,49,31)];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useInstruments"]) {
		[switchInstruments setOn:YES];
	} else {
		[switchInstruments setOn:NO];
	}
	[panelCats addSubview:switchInstruments];
	[panelCats bringSubviewToFront:switchInstruments];
	
	switchVehicles = [[UISwitch alloc] initWithFrame:CGRectMake(250,197,49,31)];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"useVehicles"]) {
		[switchVehicles setOn:YES];
	} else {
		[switchVehicles setOn:NO];
	}
	[panelCats addSubview:switchVehicles];
	[panelCats bringSubviewToFront:switchVehicles];
	
	[switchAnimals addTarget:self action:@selector(swapAnimals) forControlEvents:UIControlEventValueChanged];
	[switchFoodDrink addTarget:self action:@selector(swapFoodDrink) forControlEvents:UIControlEventValueChanged];
	[switchInstruments addTarget:self action:@selector(swapInstruments) forControlEvents:UIControlEventValueChanged];
	[switchVehicles addTarget:self action:@selector(swapVehicles) forControlEvents:UIControlEventValueChanged];
}

- (void) swapAnimals {
	if ([switchAnimals isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useAnimals"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useAnimals"];
    }
}

- (void) swapFoodDrink {
	if ([switchFoodDrink isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useFood"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useFood"];
    }
}

- (void) swapInstruments {
	if ([switchInstruments isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useInstruments"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useInstruments"];
    }
}

- (void) swapVehicles {
	if ([switchVehicles isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useVehicles"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useVehicles"];
    }
}

@end
