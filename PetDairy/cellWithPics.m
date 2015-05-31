//
//  cellWithPics.m
//  PetDairy
//
//  Created by Tommy on 2015-05-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "cellWithPics.h"


@implementation cellWithPics

- (void)awakeFromNib {
    // Initialization code
    self.content.editable = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
