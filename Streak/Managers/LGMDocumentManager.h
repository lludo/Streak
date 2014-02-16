//
//  LGMDocumentManager.h
//  Streak
//
//  Created by Ludovic Landry on 2/9/14.
//  Copyright (c) 2014 Little Green Men. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * This class is the focal point for managing and saving
 * content to CoreData.
 *
 * @since 1.0.0
 */
@interface LGMDocumentManager : NSObject

/**
 * An NSManagedObjectContext bound to the main thread.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
 * Return the shared singleton instance.
 */
+ (LGMDocumentManager *)sharedDocument;

/**
 * Save the managed object context if needed.
 */
- (void)save;

/**
 * Reset the persistent store to an empty one ready to be used. Returns YES
 * on success.
 */
- (BOOL)resetStore;

@end
