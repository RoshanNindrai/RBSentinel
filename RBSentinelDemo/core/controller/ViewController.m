//
//  ViewController.m
//  RBSentinelDemo
//
//  Created by Roshan Nindrai Senthilnathan on 5/24/15.
//  Copyright (c) 2015 Roshan Nindrai Senthilnathan. All rights reserved.
//

#import "ViewController.h"
#import "Sentinel.h"

@interface ViewController ()

@property(nonatomic, strong)Sentinel *sentinel;
@property (weak, nonatomic) IBOutlet UITextField *userInput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sentinel = [[Sentinel alloc] initWithGroupIdentifier:@"group.sentinel"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSendData:(id)sender {
    
    
    if(self.userInput.text.length > 0)
        [self.sentinel didUpdateResource:@"message" withContent:self.userInput.text];
    
}


@end

