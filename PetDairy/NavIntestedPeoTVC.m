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
    
    PFQuery *query = [PFUser query];
    
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *pfuser in objects) {
                usersData *user = [[usersData alloc]init];
                user.username = pfuser[@"username"];
                user.email = pfuser[@"email"];
                user.gender = (int)pfuser[@"gender"];
                user.createdDate = pfuser[@"createdAt"];
                user.objectId = pfuser[@"objectId"];
                NSData *imgData = pfuser[@"profileImg"];
                if (imgData) {
                    UIImage *img = [[UIImage alloc]initWithData:imgData];
                    user.profileImg = img;
                }
                
                [weakSelf.users addObject:user];
                

            }
            
            dispatch_queue_t q = dispatch_get_main_queue();
            dispatch_async(q, ^{
                [self.tableView reloadData];
            });
  
        }
        
    }];
//    PFQuery *queryF = [[PFQuery alloc]initWithClassName:@"followers"];
//
//    [queryF findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            for (PFObject *follower in objects) {
//                Followers *followerData = [[Followers alloc]init];
//                followerData.follower = follower[@"follower"];
//                followerData.following = follower[@"following"];
//                [self.followers addObject:followerData];
//            }
//            dispatch_queue_t q = dispatch_get_main_queue();
//            dispatch_sync(q, ^{
//                [self.tableView reloadData];
//            });
//        }
//    }];
    
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
    

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
