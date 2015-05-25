//
//  cellForFriends.h
//  PetDairy
//
//  Created by Tommy on 2015-05-25.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellForFriends : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *GenderIcon;
@property (weak, nonatomic) IBOutlet UILabel *experienceValue;
@property (weak, nonatomic) IBOutlet UILabel *InterestedNum;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
- (IBAction)addOrDel:(id)sender;

@end
