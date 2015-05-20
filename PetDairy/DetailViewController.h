//
//  DetailViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-05-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
- (IBAction)leftNavBtn:(id)sender;
- (IBAction)rightNavBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *leftCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *MCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *RCommentLabel;
@property (weak, nonatomic) IBOutlet UITextView *ContentTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *picsScrollView;

@end
