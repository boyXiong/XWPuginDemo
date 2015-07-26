//
//  XWPuginDemo.m
//  XWPuginDemo
//
//  Created by key on 15/7/26.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWPuginDemo.h"

@interface XWPuginDemo ()

@property (nonatomic,copy) NSString *selectedText;

@end

@implementation XWPuginDemo

#pragma mark - 调用 +pluginDidLoad:中 初始化单例
+ (void) pluginDidLoad: (NSBundle*) plugin {
    [self shared];
}


#pragma mark - 创建单例
+(id) shared {

    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        instance = [[self alloc] init];
    });
    return instance;
}


#pragma mark - 初始化
- (id)init {
    if (self = [super init]) {
        //1.监听 程序已经完全启动完毕
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - 实现监听后调用的方法
- (void) applicationDidFinishLaunching: (NSNotification*) noti {

    //1.监听选择
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectionDidChange:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:nil];

    //2.获取到Xcode 导航条的 Edit 编辑菜单 选项
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];



    if (editMenuItem) {

        //3.添加 到Xcode 导航条的 Edit 编辑菜单 选项

        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"What is selected" action:@selector(showSelected:) keyEquivalent:@""];
        [newMenuItem setTarget:self];
        [newMenuItem setKeyEquivalentModifierMask: NSAlternateKeyMask];

        [[editMenuItem submenu] addItem:newMenuItem];
    }
}


#pragma mark - 实现监听后调用的方法
-(void) selectionDidChange:(NSNotification *)noti {
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView* textView = (NSTextView *)[noti object];

        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count==0) {
            return;
        }

        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString* text = textView.textStorage.string;
        self.selectedText = [text substringWithRange:selectedRange];
    }
}

#pragma mark - 选择后调用
-(void) showSelected:(NSNotification *)noti {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText: self.selectedText];
    [alert runModal];
}

@end
