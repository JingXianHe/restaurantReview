//
//  DetailParseViewController.h
//  PetDairy
//
//  Created by Tommy on 2015-06-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailParseViewController : UIViewController
- (IBAction)leftNav;
- (IBAction)rightNav;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *leftCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *MCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *RCommentLabel;
@property (weak, nonatomic) IBOutlet UITextView *ContentTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *picsScrollView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewConstant;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleBar;
@property (weak, nonatomic) IBOutlet UIButton *geoIndicator;
@property(nonatomic, assign)CGFloat latitude;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageViewHeight;
@property(nonatomic, assign)CGFloat longitude;
@end
