//
//  AppDelegate.m
//  myOCR
//
//  Created by ScottLiu on 10/29/19.
//  Copyright © 2019 Scott Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "SLScreenshot.h"
#import "SLTesseract.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) NSMenu *menu;
@property (strong) NSMenuItem *menuItemOne;
@property (strong) NSMenuItem *menuItemTwo;
@property (strong) NSMenuItem *menuItemThree;
@property (strong) NSMenuItem *menuItemFour;
@property (strong) NSMenuItem *menuItemQuit;

@end

@implementation AppDelegate

bool hotkeys_enabled;
bool autoformat_enabled;
bool preview_enabled;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self resetVariables];
    
    [self PutStatusItemOnSystemBar];
    
    [self InitializeMenu];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)resetVariables {
    hotkeys_enabled = false;
    autoformat_enabled = false;
    preview_enabled = false;
}

- (void)PutStatusItemOnSystemBar {
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    self.statusItem.title = @"";
    
    // The image that will be shown in the menu bar, a 16x16 black png works best
    self.statusItem.image = [NSImage imageNamed:@"StatusBarButtonImage"];
    
    // The highlighted image, use a white version of the normal image
    self.statusItem.alternateImage = [NSImage imageNamed:@"StatusBarButtonImageInverted"];
    
    // The image gets a blue background when the item is selected
    self.statusItem.highlightMode = YES;
}


- (void)InitializeMenu {
    
    // initialize the menu itself
    self.menu = [[NSMenu alloc] init];
    
    // initialize the menu items
    self.menuItemOne = [self.menu addItemWithTitle:@"" action:@selector(OptionOne) keyEquivalent:@""];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    self.menuItemTwo = [self.menu addItemWithTitle:@"" action:@selector(OptionTwo) keyEquivalent:@""];
    self.menuItemThree = [self.menu addItemWithTitle:@"" action:@selector(OptionThree) keyEquivalent:@""];
    self.menuItemFour = [self.menu addItemWithTitle:@"" action:@selector(OptionFour) keyEquivalent:@""];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    self.menuItemQuit = [self.menu addItemWithTitle:@"" action:@selector(OptionQuit) keyEquivalent:@""];
    
    // populate the text for the menu items
    [self UpdateMenuItemOne];
    [self UpdateMenuItemTwo];
    [self UpdateMenuItemThree];
    [self UpdateMenuItemFour];
    [self UpdateMenuItemQuit];
    
    self.statusItem.menu = self.menu;
}

// You must initialize the menu items before calling these functions
- (void)UpdateMenuItemOne {
    NSString* startTitle;
    if (hotkeys_enabled) {
        startTitle = @"Begin myOCR\t(F1)";
    } else {
        startTitle = @"Begin myOCR";
    }
    [self.menuItemOne setTitle:startTitle];
}
- (void)UpdateMenuItemTwo {
    NSString* hotkeyTitle;
    if (hotkeys_enabled) {
        hotkeyTitle = @"Hotkeys\t\t\tON";
    } else {
        hotkeyTitle = @"Hotkeys\t\t\tOFF";
    }
    [self.menuItemTwo setTitle:hotkeyTitle];
}
- (void)UpdateMenuItemThree {
    NSString* autoformatTitle;
    if (autoformat_enabled) {
        autoformatTitle = @"Auto-format\t\tON";
    } else {
        autoformatTitle = @"Auto-format\t\tOFF";
    }
    [self.menuItemThree setTitle:autoformatTitle];
}
- (void)UpdateMenuItemFour {
    NSString* previewTitle;
    if (preview_enabled) {
        previewTitle = @"Preview\t\t\tON";
    } else {
        previewTitle = @"Preview\t\t\tOFF";
    }
    [self.menuItemFour setTitle:previewTitle];
}
- (void)UpdateMenuItemQuit {
    [self.menuItemQuit setTitle:@"Quit myOCR"];
}


- (void)OptionOne {
    // start the OCR
    [self BeginOCR];
}

- (void)OptionTwo {
    // toggle the hotkeys
    hotkeys_enabled = !hotkeys_enabled;
    [self UpdateMenuItemOne];
    [self UpdateMenuItemTwo];
}

- (void)OptionThree {
    // toggle the auto-format
    autoformat_enabled = !autoformat_enabled;
    [self UpdateMenuItemThree];
}

- (void)OptionFour {
    // toggle the preview
    preview_enabled = !preview_enabled;
    [self UpdateMenuItemFour];
}

- (void)OptionQuit {
    // quit the app
    [NSApp terminate:self];
}

- (void)BeginOCR {
    [SLScreenshot TakeScreenshot:^(NSImage* screenshot){
        NSString* text = [self imageToText:screenshot];
        // Copy to pasteboard
        [[NSPasteboard generalPasteboard] clearContents];
        [[NSPasteboard generalPasteboard] setString:text forType:NSPasteboardTypeString];
    }];
}

- (NSString*) imageToText:(NSImage*)image{
    SLTesseract *ocr = [[SLTesseract alloc] init];
    ocr.language = @"eng";
    NSString *text = [ocr recognize:image];
    return text;
}

@end
