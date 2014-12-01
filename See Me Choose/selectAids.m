//
//  selectAids.m
//  See Me Choose
//
//  Created by Ian on 13/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "selectAids.h"

@implementation selectAids
- (id) init:(UIView *)containerView {
	self = [super init];
	
	if (self) {
		view=containerView;
		[self displayAids];
	}
	
	return self;
}

- (void) displayAids {
	// Display the background panel for choosing categories
	
	UIView *panelAids;
	
	panelAids = [[UIView alloc] initWithFrame:CGRectMake(605, 362, 338, 267)];
	panelAids.backgroundColor = [UIColor yellowColor];
	[view addSubview:panelAids];
	[view bringSubviewToFront:panelAids];
	
	UIImageView *frameAids;
	
	frameAids = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 338, 267)];
	frameAids.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frameSmall" ofType:@"png"]];
	[panelAids addSubview:frameAids];
	[panelAids bringSubviewToFront:frameAids];
	
	UILabel *use2or4Label = [[UILabel alloc] initWithFrame:CGRectMake(30, 38, 277, 36)];
	use2or4Label.text = @"Do you want 4 buttons?";
	[panelAids addSubview:use2or4Label];
	[panelAids bringSubviewToFront:use2or4Label];
	
	use2or4 = [[UISwitch alloc] initWithFrame:CGRectMake(249, 41, 49, 31)];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseUse4"]) {
		[use2or4 setOn:YES];
	} else {
		[use2or4 setOn:NO];
	}
	[panelAids addSubview:use2or4];
	[panelAids bringSubviewToFront:use2or4];
	[use2or4 addTarget:self action:@selector(swap2or4) forControlEvents:UIControlEventValueChanged];
	
	UILabel *announceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 277, 36)];
	announceLabel.text = @"Announce item name?";
	[panelAids addSubview:announceLabel];
	[panelAids bringSubviewToFront:announceLabel];
	
	useAnnounce = [[UISwitch alloc] initWithFrame:CGRectMake(249, 93, 49, 31)];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseAnnounce"]) {
		[useAnnounce setOn:YES];
	} else {
		[useAnnounce setOn:NO];
	}
	[panelAids addSubview:useAnnounce];
	[panelAids bringSubviewToFront:useAnnounce];
	[useAnnounce addTarget:self action:@selector(swapAnnounce) forControlEvents:UIControlEventValueChanged];
	
	UILabel *highlightLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 142, 277, 36)];
	highlightLabel.text = @"Highlight correct item?";
	[panelAids addSubview:highlightLabel];
	[panelAids bringSubviewToFront:highlightLabel];
	
	useHighlight = [[UISwitch alloc] initWithFrame:CGRectMake(249, 145, 49, 31)];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"seeMeChooseHighlight"]) {
		[useHighlight setOn:YES];
	} else {
		[useHighlight setOn:NO];
	}
	[panelAids addSubview:useHighlight];
	[panelAids bringSubviewToFront:useHighlight];
	[useHighlight addTarget:self action:@selector(swapHighlight) forControlEvents:UIControlEventValueChanged];
	
	NSString *timeLabelPart1 = @"after";
	useTime1Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	CGSize labSize = [timeLabelPart1 sizeWithAttributes:@{NSFontAttributeName:[useTime1Label font]}];
	[useTime1Label setFrame:CGRectMake(160, 194, labSize.width, 36)];
	useTime1Label.text = timeLabelPart1;
	[panelAids addSubview:useTime1Label];
	[panelAids bringSubviewToFront:useTime1Label];
	
	useTimePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(useTime1Label.frame.origin.x + useTime1Label.frame.size.width, 105, 35, 0)];
	useTimePicker.delegate = self;
	useTimePicker.showsSelectionIndicator = NO;
	[panelAids addSubview:useTimePicker];
	[panelAids bringSubviewToFront:useTimePicker];
	[useTimePicker selectRow:[[NSUserDefaults standardUserDefaults]integerForKey:@"seeMeChooseSeconds"] inComponent:0 animated:NO];
	
	useTime2Label = [[UILabel alloc] initWithFrame:CGRectMake(useTimePicker.frame.origin.x + useTimePicker.frame.size.width, 194, 70, 36)];
	useTime2Label.text = @"seconds";
	[panelAids addSubview:useTime2Label];
	[panelAids bringSubviewToFront:useTime2Label];
	
	if ([useHighlight isOn]) {
		[useTime1Label setHidden:NO];
		[useTimePicker setHidden:NO];
		[useTime2Label setHidden:NO];
	} else {
		[useTime1Label setHidden:YES];
		[useTimePicker setHidden:YES];
		[useTime2Label setHidden:YES];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
	NSLog(@"Selected: %ld",(long)row);
	[[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"seeMeChooseSeconds"];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 21;
	
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%ld",(long)row];
	
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	int sectionWidth = 35;
	
	return sectionWidth;
}

- (void) swap2or4 {
	if ([use2or4 isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"seeMeChooseUse4"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"seeMeChooseUse4"];
    }
}

- (void) swapAnnounce {
	if ([useAnnounce isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"seeMeChooseAnnounce"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"seeMeChooseAnnounce"];
    }
}

- (void) swapHighlight {
	if ([useHighlight isOn]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"seeMeChooseHighlight"];
		[useTime1Label setHidden:NO];
		[useTimePicker setHidden:NO];
		[useTime2Label setHidden:NO];

    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"seeMeChooseHighlight"];
		[useTime1Label setHidden:YES];
		[useTimePicker setHidden:YES];
		[useTime2Label setHidden:YES];
    }
}

@end
