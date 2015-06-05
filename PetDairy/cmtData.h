//
//  cmtData.h
//  PetDairy
//
//  Created by Tommy on 2015-06-05.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface cmtData : NSObject
@property(copy, nonatomic)NSString *content;
@property(copy, nonatomic)NSString *username;
@property(copy, nonatomic)UIImage *profileImg;
@property(copy, nonatomic)NSDate *date;
@end
