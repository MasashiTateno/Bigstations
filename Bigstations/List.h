//
//  List.h
//  Bigstations
//
//  Created by Tateno Masashi on 2013/02/09.
//  Copyright (c) 2013年 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface List : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;

@end
