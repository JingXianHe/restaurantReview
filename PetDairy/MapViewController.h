//
//  MapViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-05-22.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
-(void)setGeolocation;
@property(assign, nonatomic)CGFloat latitude;
@property(assign, nonatomic)CGFloat longitude;

@property(copy,nonatomic)NSString *title;

@end
