//
//  PoiViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-06-12.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"


@interface PoiViewController : UIViewController
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *street;
@property(copy, nonatomic)NSString *endCity;
@property(copy, nonatomic)NSString *endStreet;
@property(copy, nonatomic)NSString *keyWord;
@property(assign, nonatomic)CLLocationCoordinate2D currentLocation;
@property(assign, nonatomic)CLLocationCoordinate2D targetLocation;
@property(assign, nonatomic)int pageCapacity;
@property(assign, nonatomic)int radius;
@property(assign, nonatomic)float navHeight;
@end
