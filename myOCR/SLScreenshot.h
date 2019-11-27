//
//  SLScreenshot.h
//  Screenshot-OCR
//
//  Created by ScottLiu on 4/26/18.
//  Copyright © 2018 Scott Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLScreenshot : NSObject

// standard init
- (instancetype)init;
// alternative init if you dont want event taps (cannot call saveScreenshotFromUpperLeft:(NSPoint)ul ToLowerRight:(NSPoint)lr)
- (instancetype)initWithoutTaps;
// in case you need to create event taps after initiallizing without them
- (void)createEventTaps;

// easy to use, heres an example:
//          SLScreenshot *shooter = [[SLScreenshot alloc] init];
//          [shooter TakeScreenshot:^(NSImage* ss){
//              [self.ssImageView setImage:ss];
//          }];
- (void)TakeScreenshot:(void (^)(NSImage* image))completionBlock; // returns the screenshot in the completion block


// more difficult to use
- (void)saveScreenshotFromUpperLeft:(NSPoint)ul ToLowerRight:(NSPoint)lr; // saves to desktop
- (NSImage *)ScreenshotToNSImageFromUpperLeft:(NSPoint)ul ToLowerRight:(NSPoint)lr;
- (NSImage *)ScreenshotTo300dpiNSImageFromUpperLeft:(NSPoint)ul ToLowerRight:(NSPoint)lr;

@end
