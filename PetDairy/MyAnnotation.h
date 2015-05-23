//
//  MyAnnotation.h
//  PetDairy
//
//  Created by Tommy on 2015-05-22.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>
@property(nonatomic, readonly)CLLocationCoordinate2D coordinate;
@property(nonatomic, copy,readonly)NSString *title;
@property(nonatomic, copy, readonly)NSString *subtitle;
-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramTitle;
@end
