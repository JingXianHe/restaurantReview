//
//  UIView+Alert.m
//  testImgFile
//
//  Created by Tommy on 2015-06-11.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "UIView+Alert.h"

@implementation UIView (Alert)
+(void)alertWith:(NSString *)title message:(NSString *)message{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
}
@end
