//
//  LoginVC.m
//  FKApiInvoker
//
//  Created by CHAT on 2019/9/27.
//  Copyright © 2019 CHAT. All rights reserved.
//

#import "LoginVC.h"
#import <SVProgressHUD.h>

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)login:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
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
