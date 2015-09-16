//
//  LoginViewController.m
//  500px
//
//  Created by Liz Chaddock on 9/16/15.
//  Copyright (c) 2015 Liz Chaddock. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController
- (IBAction)logIn:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                [self performSegueWithIdentifier:@"LogMeIn" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error logging in: " message:[error localizedDescription] delegate:self cancelButtonTitle:@"Close"otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
}

- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"LogMeIn" sender:self];
        } else {   NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error signing up: " message:errorString delegate:self cancelButtonTitle:@"Close"otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
