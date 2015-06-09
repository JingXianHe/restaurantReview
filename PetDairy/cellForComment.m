//
//  cellForComment.m
//  PetDairy
//
//  Created by Tommy on 2015-06-07.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "cellForComment.h"

@implementation cellForComment

- (void)awakeFromNib {
    // Initialization code
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    self.content.numberOfLines = 0;
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2;
    self.profileImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
