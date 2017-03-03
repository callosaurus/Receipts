//
//  CoreDataManager.h
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Receipts__+CoreDataModel.h"

@interface CoreDataManager : NSObject

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSArray *fetchedTags;
@property (nonatomic) NSArray *fetchedReceipts;

+(instancetype)sharedInstance;
-(NSArray *)fetchReceipts;
-(NSArray *)fetchTags;

@end
