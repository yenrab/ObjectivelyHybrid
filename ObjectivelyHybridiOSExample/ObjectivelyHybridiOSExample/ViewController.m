//
//  ViewController.m
//  ObjectivelyHybridiOSExample
//
//  Created by Lee Barney on 10/31/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

#import "ViewController.h"
#import "WebMover.h"
#import <ObjectivelyHybridiOSExample-Swift.h>

@interface ViewController ()
@property (strong, nonatomic)WKWebView *appWebView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     * This line of code doesn't work in an Objective-C project. This appears to be a defect. The web files need to be
     * moved into the application's temp directory.
     
     NSString *indexHTMLPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
     
     */
    
    NSError *moveError = nil;
    //modify the array of file types to fit the web file types your app uses.
    NSString *indexHTMLPath = [WebMover moveDirectoriesAndWebFilesOfType:@[@"js",@"css",@"html",@"png",@"jpg",@"gif"] error:&moveError];
    if (moveError != nil) {
        NSLog(@"%@",moveError.description);
    }
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    [theConfiguration.userContentController addScriptMessageHandler:self name:@"interOp"];
    _appWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    
    //The Objective-C URLWithString creates a URL that fails to load
    //when used in a NSURLRequest that is later consumed by
    //NSURL *url = [NSURL URLWithString:indexHTMLPath];
    NSURL *url = [SwiftlyBridge buildURL:indexHTMLPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_appWebView loadRequest:request];
    [self.view addSubview:_appWebView];

}
/*
 * Change the behavior of this method to match what you need for your app.
 */
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary * sentData = (NSDictionary*)message.body;
    int aCount = [sentData[@"count"] intValue];
    [_appWebView evaluateJavaScript:[NSString stringWithFormat:@"storeAndShow(%d)",aCount + 1] completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
