//
//  NearBySearchViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-06-11.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearBySearchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *searchRange;
@property (weak, nonatomic) IBOutlet UISlider *searchQuantity;
- (IBAction)rangeValue:(id)sender;
- (IBAction)quantityChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *rangeDisplay;
@property (weak, nonatomic) IBOutlet UILabel *quantityDisplay;

@end
