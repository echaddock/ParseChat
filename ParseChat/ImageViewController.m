//
//  ImageViewController.m
//  500px
//
//  Created by Liz Chaddock on 9/16/15.
//  Copyright (c) 2015 Liz Chaddock. All rights reserved.
//

#import "ImageViewController.h"
#import <Parse/Parse.h>
#import "MessageCell.h"

@interface ImageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *messages;
@end

@implementation ImageViewController
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    cell.messageLabel.text = self.messages[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void) onTimer {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"text"]);
                [self.messages addObject:object[@"text"]];
            }
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)createMessage:(id)sender {
    PFObject *msg = [PFObject objectWithClassName:@"Message"];
    msg[@"text"] = self.messageField.text;
    [msg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"success");
        } else {
            // There was a problem, check error.description
            NSLog(@"fail");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector: @selector(onTimer) userInfo:nil repeats:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    [self onTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
