//
//  cellForPost.m
//  PetDairy
//
//  Created by Tommy on 2015-05-31.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "cellForPost.h"

@implementation cellForPost

- (void)awakeFromNib {
    // Initialization code
    self.indicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_indicator"]];
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2;
    self.profileImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
