//
//  HTableViewCell.h
//  PetDairy
//
//  Created by Tommy on 2015-05-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicator;
@property (weak, nonatomic) IBOutlet UILabel *timeTint;
@property (weak, nonatomic) IBOutlet UILabel *TitleTint;
@property (weak, nonatomic) IBOutlet UILabel *tasteS;
@property (weak, nonatomic) IBOutlet UILabel *serviceS;
@property (weak, nonatomic) IBOutlet UILabel *satisfyS;

@end
