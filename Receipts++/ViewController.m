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
    
    self.tagsArray = [NSArray arrayWithObjects: @[@"Personal", @"Family", @"Business"], nil];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDel.managedObjectContext;
    //make tags
    
    [self createReceipt];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchReceipt];
    [self.receiptTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchReceipt
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *readError;
    
    self.receiptsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&readError];
    
//    NSLog(@"%@", self.receiptsArray);
}

- (void)createReceipt {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Receipt"
                                                         inManagedObjectContext:self.managedObjectContext];
    Receipt *receipt = [[Receipt alloc] initWithEntity:entityDescription
                        insertIntoManagedObjectContext:self.managedObjectContext];
    
    receipt.amount = [@50 floatValue];;
    receipt.note = @"Testing";
    
    NSError *createError = nil;
    
    if (![receipt.managedObjectContext save:&createError]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", createError, createError.localizedDescription);
    }
    
}

#pragma mark - Table View -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.receiptsArray[section] count];
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Receipt *receipt = [self.receiptsArray objectAtIndex:0];
    cell.noteLabel.text = receipt.note;
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f",receipt.amount];
    return cell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//}



@end
