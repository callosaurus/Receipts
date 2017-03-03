//
//  CoreDataManager.m
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+(instancetype)sharedInstance
{
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
    });
    
    return sharedInstance;
}

-(NSArray *)fetchReceipts
{
    NSArray *arrayOfReceipts = [NSArray new];
    
    //execute fetch request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Receipt"];
    arrayOfReceipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    self.fetchedReceipts = arrayOfReceipts;
    
    return arrayOfReceipts;
}


-(NSArray *)fetchTags
{
    NSArray *arrayOfTags;
    
    //execute fetch request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    arrayOfTags = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //if fetch was empty, make new tags
    if (arrayOfTags.count == 0 || arrayOfTags == nil) {
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
        
        Tag *personal = [[Tag alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        personal.tagName = @"Personal";
        
        Tag *family = [[Tag alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        family.tagName = @"Family";
        
        Tag *business = [[Tag alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        business.tagName = @"Business";
        
        arrayOfTags = @[personal, family, business];
        
        [self.managedObjectContext save:nil];
        
    }
    
    self.fetchedTags = arrayOfTags;
    
    return arrayOfTags;
}

@end
