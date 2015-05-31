//
//  cellWithPics.h
//  PetDairy
//
//  Created by Tommy on 2015-05-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellWithPics : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *timeTint;
@property (weak, nonatomic) IBOutlet UILabel *TitleTint;
@property (weak, nonatomic) IBOutlet UILabel *tasteS;
@property (weak, nonatomic) IBOutlet UILabel *serviceS;
@property (weak, nonatomic) IBOutlet UILabel *satisfyS;
@property (weak, nonatomic) IBOutlet UIImageView *mapIndicator;

@property (weak, nonatomic) IBOutlet UITextView *content;

@end
