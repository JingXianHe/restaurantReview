//
//  TitleButton.h
//  PetDairy
//
//  Created by Tommy on 2015-05-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TitleButton : UIButton
@property(nonatomic, copy)NSString *title;
@property(nonatomic, strong)PFUser *currentUser;
@end
