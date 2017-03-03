//
//  ViewController.m
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import "ViewController.h"
#import "NewReceiptController.h"
#import "ReceiptCell.h"
#import "Receipts__+CoreDataModel.h"

#import "AppDelegate.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *receiptsArray;
@property (nonatomic) NSArray *tagsArray;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *receiptTableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDel.managedObjectContext;
    self.coreDataManager = [CoreDataManager sharedInstance];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.coreDataManager fetchTags];
    [self.coreDataManager fetchReceipts];
    [self.receiptTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addNewReceipt"]) {
        
        NewReceiptController *controller = [NewReceiptController new];
//        controller.managedObjectContext = self.managedObjectContext;
//        controller.tagsArray = self.tagsArray;
        controller = segue.destinationViewController;
        [self.receiptTableView reloadData];
    }
}

#pragma mark - Table View -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.coreDataManager.fetchedTags count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.receiptsArray.count;
    return [[self.coreDataManager fetchReceipts]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *fetchedReceipts = [self.coreDataManager fetchReceipts];
    Receipt *receipt = [fetchedReceipts objectAtIndex:indexPath.row];
//    Receipt *receipt = self.receiptsArray/*[indexPath.section]*/[indexPath.row];
    cell.noteLabel.text = receipt.note;
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f",receipt.amount];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Tag *tagSectionName = self.coreDataManager.fetchedTags[section];
    return tagSectionName.tagName;
}

@end
