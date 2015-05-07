//
//  LeftMenu.h
//  PetDairy
//
//  Created by Tommy on 2015-05-05.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftMenu;

@protocol LeftMenuDelegate <NSObject>
@optional
- (void)leftMenu:(LeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex;
@end
@interface LeftMenu : UIView
@property (nonatomic, weak) id<LeftMenuDelegate> delegate;
@end
