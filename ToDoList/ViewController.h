//
//  ViewController.h
//  ToDoList
//
//  Created by Desmond Wong on 21/03/2020.
//  Copyright © 2020 Desmond Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface ViewController : UITableViewController

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

