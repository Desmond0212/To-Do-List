//
//  ToDoArray.m
//  ToDoList
//
//  Created by Desmond Wong on 24/03/2020.
//  Copyright © 2020 Desmond Wong. All rights reserved.
//

#import "ToDoArray.h"

@implementation ToDoArray

@synthesize data;
@synthesize location;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        data = nil;
        location = nil;
    }
    
    return self;
}

@end
