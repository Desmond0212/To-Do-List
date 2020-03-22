//
//  ViewController.m
//  ToDoList
//
//  Created by Desmond Wong on 21/03/2020.
//  Copyright © 2020 Desmond Wong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSArray *categories;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.items = @[@{@"name": @"take out the trash", @"category": @"Home"}, @{@"name": @"go shopping", @"category": @"Home"}].mutableCopy;
    self.categories = @[@"Home"]; //, @"Work"
    self.navigationItem.title = @"To-Do-List";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(tongleEditing:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
}

#pragma mark - Editing Items

- (void)tongleEditing:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
    {
        sender.title = @"Done";
        sender.style = UIBarButtonItemStyleDone;
    }
    else
    {
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStylePlain;
    }
}

#pragma mark - Adding Items

- (void)addNewItem:(UIBarButtonItem *)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"New To-Do-List Item" message:@"Please enter the name of the New TO-DO Itme" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Insert your note here...";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
    }];
    
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"Add Item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *itemName = alert.textFields.firstObject.text;
        NSDictionary *item = @{@"name": itemName, @"category": @"Home"};
        [self.items addObject:item];
        NSInteger numHomeItems = [self numberOfItemInCategory:@"Home"];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:numHomeItems - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                     }];
    
    UIAlertAction * actionCANCEL = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         //Add Another Action
                     }];

    [alert addAction:actionOK];
    [alert addAction:actionCANCEL];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Datasource helper methods

- (NSArray *)itemsInCategory:(NSString *)targetCategory
{
    NSPredicate *matchingPredicate = [NSPredicate predicateWithFormat:@"category == %@", targetCategory];
    NSArray *categoryItems = [self.items filteredArrayUsingPredicate:matchingPredicate];
    
    return categoryItems;
}

- (NSInteger)numberOfItemInCategory:(NSString *)targetCategory
{
    return [self itemsInCategory:targetCategory].count;
}

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *category = self.categories[indexPath.section];
    NSArray *categoryItems = [self itemsInCategory:category];
    NSDictionary *item = categoryItems[indexPath.row];
    
    return item;
}

- (NSInteger)itemIndexForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    NSInteger index = [self.items indexOfObjectIdenticalTo:item];
    
    return index;
}

- (void)removeItemsAtIndexes:(NSIndexPath *)indexPath
{
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    [self.items removeObjectAtIndex:index];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.items.count;
    return [self numberOfItemInCategory:self.categories[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ToDoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //NSDictionary *item = self.items[indexPath.row];
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    
    cell.textLabel.text = item[@"name"];
    
    if ([item[@"completed"] boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.categories[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    NSMutableDictionary *item = [self.items[index] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    
    self.items[index] = item;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self removeItemsAtIndexes:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
