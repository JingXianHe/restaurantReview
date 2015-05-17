//
//  HCmtDataModal.h
//  PetDairy
//
//  Created by Tommy on 2015-05-16.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCmtDataModal : NSObject
@property(assign, nonatomic)int idComent;
@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *content;
@property(assign, nonatomic)int servicecmt;
@property(assign, nonatomic)int tastecmt;
@property(assign, nonatomic)int satisfycmt;
@property(assign, nonatomic)float latitude;
@property(assign, nonatomic)float longitude;
@property(assign, nonatomic)int isImage;
@property(strong, nonatomic)NSMutableArray *imgCollections;
@end
