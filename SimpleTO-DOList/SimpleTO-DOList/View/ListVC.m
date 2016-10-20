//
//  ListVC.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "ListVC.h"
#import "ItemVC.h"
#import "AlertControllerFactory.h"

static NSString *ListCellID = @"ListCell";

@interface ListVC ()

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSFetchRequest *fetchRequest = [List MR_createFetchRequest];
    fetchRequest.sortDescriptors = @[];
    self.fetchedResultsController = [List MR_fetchController:fetchRequest delegate:self useFileCache:NO groupedBy:nil inContext:[NSManagedObjectContext MR_defaultContext]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[ItemVC class]]) {
        List *selectedList = self.fetchedResultsController.fetchedObjects[self.tableView.indexPathForSelectedRow.row];
        ItemVC *destinationVC = segue.destinationViewController;
        destinationVC.selectedList = selectedList;
    }
}

#pragma mark - Actions

- (IBAction)addTapped:(UIBarButtonItem *)sender
{
    UIAlertController *alertController =
    [AlertControllerFactory textFieldAlertControllerWithTitle:@"Give a name to your list:"
                                               andPlaceHolder:@"Type here the list name"
                                            completionHandler:^(NSString *text) {
                                                [self createListWithName:text];
                                            }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createListWithName:(NSString *)name
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        List *newList = [List MR_createEntityInContext:localContext];
        newList.name = name;
    }];
}

#pragma - mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ListCellID];
    }
    
    List *list = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = list.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu item%@", list.items.count, (list.items.count > 1) ? @"s" : @""];
    
    return cell;
}

@end
