//
//  YWViewController.m
//  YWTableExcel
//
//  Created by flyOfYW on 12/11/2019.
//  Copyright (c) 2019 flyOfYW. All rights reserved.
//

#import "YWViewController.h"
#import "YWDemo1.h"
#import "YWDemo2.h"
#import "YWDemo3.h"

@interface YWViewController ()

@end

@implementation YWViewController


- (IBAction)defalutAction:(id)sender {
    YWDemo1 *ctr = [YWDemo1 new];
    [self.navigationController pushViewController:ctr animated:YES];
}
- (IBAction)planAction:(id)sender {
    YWDemo2 *ctr = [YWDemo2 new];
    [self.navigationController pushViewController:ctr animated:YES];
}
- (IBAction)sectionAction:(id)sender {
    YWDemo3 *ctr = [YWDemo3 new];
     [self.navigationController pushViewController:ctr animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad{
    NSLog(@"viewDidLoad");
}

@end
