//
//  cellForFriends.m
//  PetDairy
//
//  Created by Tommy on 2015-05-25.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "cellForFriends.h"

@implementation cellForFriends

- (void)awakeFromNib {
    // Initialization code
    self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.height / 2;
    self.GenderIcon.layer.cornerRadius = self.GenderIcon.frame.size.height / 2;
    self.followingBtn.layer.cornerRadius = self.followingBtn.frame.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addOrDel:(id)sender {
}
@end
