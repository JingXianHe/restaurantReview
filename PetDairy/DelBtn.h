//
//  DelBtn.h
//  PetDairy
//
//  Created by Tommy on 2015-06-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelBtn : UIButton
@property(copy, nonatomic)NSIndexPath *indexPath;
@property(assign, nonatomic)int commentId;
@end
