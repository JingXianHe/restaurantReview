//
//  HTableViewController.m
//  PetDairy
//
//  Created by Tommy on 2015-05-03.
//  Copyright (c) 2015 H. All rights reserved.
//

#import "HTableViewController.h"
#import "HCmtDataModal.h"
#import "HTableViewCell.h"

@interface HTableViewController ()<UITableViewDataSource>
@property (strong, nonatomic)NSMutableArray *dataItems;
@end

@implementation HTableViewController
-(NSMutableArray *)dataItems{
    if (_dataItems == Nil) {
        _dataItems = [[NSMutableArray alloc]init];
    }
    return _dataItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

-(void)refreshData{
    sqlite3 *lib;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"private_comments.sqlite"];
    sqlite3_stmt *stmt = NULL;
    const char *cFile = fileName.UTF8String;
    int result = sqlite3_open(cFile, &lib);
    if (result == SQLITE_OK) {
 
        const char *sql = "select * from comments_test6";
        if (sqlite3_prepare_v2(lib, sql, -1, &stmt, NULL)== SQLITE_OK) {
            while (sqlite3_step(stmt)== SQLITE_ROW) {

                HCmtDataModal *item = [[HCmtDataModal alloc]init];
                item.idComent = sqlite3_column_int(stmt, 0);
                item.title = [[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 1)];
                item.content = [[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 2)];
                item.servicecmt = sqlite3_column_int(stmt, 3);
                item.tastecmt = sqlite3_column_int(stmt, 4);
                item.satisfycmt = sqlite3_column_int(stmt, 5);
                item.latitude = [[[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 6)] doubleValue];
                item.longitude = [[[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 7)] doubleValue];
                item.isImage = sqlite3_column_int(stmt, 8);
                item.datevalue = [[NSString alloc]initWithUTF8String:sqlite3_column_blob(stmt, 9)];
                [self.dataItems addObject:item];

            }
        }
    }
    
    [self.tableView reloadData];
    NSArray *indexes = [self.tableView visibleCells];
    HTableViewCell *indexC = [indexes firstObject];
    indexC.indicator.image = [UIImage imageNamed:@"promoboard_icon_mall"];
    indexC.indicator.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellNormal"];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cellNormal" owner:nil options:nil] lastObject];
    }
    
    HCmtDataModal *item = self.dataItems[indexPath.row];
    
    cell.timeTint.text = [NSString stringWithFormat:@"%@", item.datevalue];
    cell.TitleTint.text = item.title;
    cell.serviceS.text = [self convertCommentP:item.servicecmt title:@"服务："];
    cell.tasteS.text = [self convertCommentP:item.tastecmt title:@"味道："];
    cell.satisfyS.text = [self convertCommentP:item.satisfycmt title:@"环境："];
    // Configure the cell...
    
    return cell;
}
//inner method to judge comment points
-(NSString *)convertCommentP:(int)p title:(NSString *)title{
    if (p == 1) {
        
        return [title stringByAppendingString:@"很差"];
        
    }else if(p == 2){
        return [title stringByAppendingString:@"一般"];
    }else{
        return [title stringByAppendingString:@"满意"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *indexes = [self.tableView visibleCells];
    HTableViewCell *indexC = [indexes firstObject];
    indexC.indicator.image = [UIImage imageNamed:@"promoboard_icon_mall"];
    indexC.indicator.backgroundColor = [UIColor whiteColor];
    
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
