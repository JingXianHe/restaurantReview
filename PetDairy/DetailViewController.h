//
//  DetailViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-05-17.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

- (IBAction)leftNav;
- (IBAction)rightNav;

@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *leftCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *MCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *RCommentLabel;
@property (weak, nonatomic) IBOutlet UITextView *ContentTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *picsScrollView;
@property (weak, nonatomic) IBOutlet UIButton *RightNavBtn;
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleBar;
@property (weak, nonatomic) IBOutlet UIButton *geoIndicator;
@property(nonatomic, assign)CGFloat latitude;
@property(nonatomic, assign)CGFloat longitude;

@end
