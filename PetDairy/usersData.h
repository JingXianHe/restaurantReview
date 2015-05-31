//
//  usersData.h
//  PetDairy
//
//  Created by Tommy on 2015-05-29.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface usersData : NSObject
@property(copy, nonatomic)NSString *email;
@property(copy, nonatomic)NSString *username;
@property(strong, nonatomic)NSDate *createdDate;
@property(assign, nonatomic)int postTimes;
@property(strong, nonatomic)UIImage *profileImg;
@property(assign, nonatomic)int gender;
@property(copy,nonatomic)NSString *objectId;
@end
