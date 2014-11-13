/*
 Copyright (c) 2014 Lee Barney
 Permission is hereby granted, free of charge, to any person obtaining a
 copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software
 is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
 OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 */

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
    [_appWebView evaluateJavaScript:[NSString stringWithFormat:@"storeAndShow(%d)",aCount + 1] completionHandler:^(id JSReturnValue, NSError* error){
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        else if (JSReturnValue != nil){
            NSLog(@"returned value: %@",JSReturnValue);
        }
        else{
            NSLog(@"no return from JS");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
