//
//  LGMResolution.h
//  Streak
//
//  Created by Ludovic Landry on 2/15/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LGMCategory;

@interface LGMResolution : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) LGMCategory *category;
@property (nonatomic, strong) NSString *frequency;

@end
