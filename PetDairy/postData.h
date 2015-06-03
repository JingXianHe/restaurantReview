//
//  postData.h
//  PetDairy
//
//  Created by Tommy on 2015-05-31.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface postData : NSObject
@property(assign, nonatomic)NSString *objectId;
@property(copy,nonatomic)NSString *username;

@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *content;
@property(assign, nonatomic)int servicecmt;
@property(assign, nonatomic)int tastecmt;
@property(assign, nonatomic)int satisfycmt;
@property(assign, nonatomic)PFGeoPoint *location;
@property(assign, nonatomic)int isImage;
@property(copy, nonatomic)NSString *datevalue;
@property(strong, nonatomic)NSMutableArray *imgCollections;
@property(strong, nonatomic)NSString *postDate;
@property(assign, nonatomic)int comments;
@end
