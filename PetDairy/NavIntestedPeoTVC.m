//
//  NavIntestedPeoTVC.m
//  PetDairy
//
//  Created by Tommy on 2015-05-23.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "NavIntestedPeoTVC.h"
#import "cellForFriends.h"
#import <Parse/Parse.h>
#import "usersData.h"
#import "Followers.h"
#import "addOrDelBtn.h"
#import "AppDelegate.h"

@interface NavIntestedPeoTVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSMutableArray *users;
@property(strong, nonatomic)NSMutableArray *followers;
@end

@implementation NavIntestedPeoTVC

-(NSMutableArray *)users{
    if (_users == nil) {
        _users = [[NSMutableArray alloc]init];
    }
    return _users;
}

-(NSMutableArray *)followers{
    if (_followers == nil) {
        _followers = [[NSMutableArray alloc]init];
    }
    return _followers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    spinner.center = self.tableView.center;
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    PFQuery *query = [PFUser query];
    
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *pfuser in objects) {
                usersData *user = [[usersData alloc]init];
                user.username = pfuser[@"username"];
                
                user.email = pfuser[@"email"];
                NSString *gender = (NSString *)pfuser[@"gender"];
                user.gender = gender.intValue;
                
                NSString *postTime = pfuser[@"postTime"];
                user.postTimes = postTime.intValue;
                user.createdDate = pfuser[@"createdAt"];
                user.objectId = pfuser[@"objectId"];
                PFFile *imgData = pfuser[@"profileImg"];
                NSData *Data = [imgData getData];
                if (Data) {
                    UIImage *img = [[UIImage alloc]initWithData:Data];
                    user.profileImg = img;
                }
                
                [weakSelf.users addObject:user];

            }
            
            dispatch_queue_t q = dispatch_get_main_queue();
            dispatch_async(q, ^{
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                [delegate.parseUserArray addObjectsFromArray:weakSelf.users];
                [spinner stopAnimating];
                [self.tableView reloadData];
                [[UIApplication sharedApplication]endIgnoringInteractionEvents];
            });
            
        }else{
            
            [spinner stopAnimating];
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        }
        
    }];
    PFQuery *queryF = [[PFQuery alloc]initWithClassName:@"followers"];
    
    [queryF findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *follower in objects) {
                Followers *followerData = [[Followers alloc]init];
                followerData.follower = follower[@"follower"];
                followerData.following = follower[@"following"];
                [weakSelf.followers addObject:followerData];
            }
            
            dispatch_queue_t q = dispatch_get_main_queue();
            dispatch_async(q, ^{
                [self.tableView reloadData];
            });
            
        }else{
            NSLog(@"%@", error.userInfo[@"error"]);

        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.users.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    usersData *data = self.users[indexPath.row];
    cellForFriends *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForFriends"];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cellForFriends" owner:nil options:nil] lastObject];
    }
    cell.nameText.text = data.username;
    
    cell.InterestedNum.text = [NSString stringWithFormat:@"%d",[self checkFollowings:data.username]];
    
    cell.experienceValue.text = [NSString stringWithFormat:@"%d",data.postTimes];
    
    if (data.profileImg) {
        cell.profileImgView.image = data.profileImg;
    }
    
    if ([self checkIfFollow:data.username]) {
        [cell.followingBtn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        [cell.followingBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    if (data.gender == 0) {
        cell.genderImg.image = [UIImage imageNamed:@"male"];
    }else{
        cell.genderImg.image = [UIImage imageNamed:@"female.jpg"];
    }

    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.followingBtn addTarget:self action:@selector(setFollowValue:) forControlEvents:UIControlEventTouchUpInside];
    cell.followingBtn.username = data.username;
    
    return cell;
    
}

#pragma for follow btn event
-(void)setFollowValue:(addOrDelBtn *)btn{
    
    btn.userInteractionEnabled = NO;
    
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        
        PFQuery *query = [[PFQuery alloc]initWithClassName:@"followers"];
        [query whereKey:@"follower" containsString:[PFUser currentUser].username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                for (PFObject *follower in objects) {
                    if ([follower[@"following"] isEqualToString:btn.username]) {
                        [follower deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                
                                dispatch_queue_t q = dispatch_get_main_queue();
                                dispatch_async(q, ^{
                                    [btn setTitle:@"关注" forState:UIControlStateNormal];
                                    btn.userInteractionEnabled = YES;
                                });
                                
                            }else{
                                dispatch_queue_t q = dispatch_get_main_queue();
                                dispatch_async(q, ^{
                                    btn.userInteractionEnabled = YES;
                                });
                            }
                        }];
                    }
                    
                }
            }

        }];
        
    }else{
        PFObject *post = [[PFObject alloc]initWithClassName:@"followers"];
        post[@"follower"] = [PFUser currentUser].username;
        post[@"following"] = btn.username;
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                dispatch_queue_t q = dispatch_get_main_queue();
                dispatch_async(q, ^{
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                    btn.userInteractionEnabled = YES;
                });
            }else{
                dispatch_queue_t q = dispatch_get_main_queue();
                dispatch_async(q, ^{
                    btn.userInteractionEnabled = YES;
                });
            }
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(int)checkFollowings:(NSString *)name{
    int count = 0;
    for (Followers *follower in self.followers) {
        if ([follower.following isEqualToString:name]) {
            count ++;
        }
    }
    return count;
}

-(BOOL)checkIfFollow:(NSString *)name{
    
    BOOL status = false;
    NSString *user = [PFUser currentUser].username;
    for (Followers *follower in self.followers) {
        if ([follower.follower isEqualToString:user]) {
            if ([follower.following isEqualToString:name]) {
                status = true;
            }
        }
    }
    return status;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
