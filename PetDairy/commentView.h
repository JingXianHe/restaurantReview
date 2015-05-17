//
//  commentView.h
//  PetDairy
//
//  Created by Tommy on 2015-05-12.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (strong, nonatomic)NSNumber *scores;
- (IBAction)unsatisfied:(id)sender;
- (IBAction)average:(id)sender;
- (IBAction)satisfied:(id)sender;

@end
