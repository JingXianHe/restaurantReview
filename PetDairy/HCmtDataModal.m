//
//  HCmtDataModal.m
//  PetDairy
//
//  Created by Tommy on 2015-05-16.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "HCmtDataModal.h"

@implementation HCmtDataModal
-(NSMutableArray *)imgCollections{
    if (_imgCollections == Nil) {
        _imgCollections = [[NSMutableArray alloc]init];
    }
    return  _imgCollections;
}
  @end
