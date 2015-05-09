//
//  PostViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-05-07.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightMenuController;

@interface PostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) RightMenuController *rightMenuController;
@end
