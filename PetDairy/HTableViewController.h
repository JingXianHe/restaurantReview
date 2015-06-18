//
//  HTableViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-05-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DelBtn.h"

@interface HTableViewController : UITableViewController
@property(nonatomic, assign)CGFloat xOffet;
-(void)refreshData;
-(void)deleteCell:(DelBtn *)btn;
@end
