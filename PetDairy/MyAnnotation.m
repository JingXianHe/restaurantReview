//
//  MyAnnotation.m
//  PetDairy
//
//  Created by Tommy on 2015-05-22.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "MyAnnotation.h"

@interface MyAnnotation()

@end
@implementation MyAnnotation
-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle{
    self = [super init];
    if (self != nil) {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubTitle;
        
    }
    return self;
}
@end
