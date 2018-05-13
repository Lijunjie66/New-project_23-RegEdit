//
//  main.m
//  New-project_23-RegEdit
//
//  Created by Geraint on 2018/5/3.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RegEdit.h"
#import "CLIParser.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        // 使用CLIParser对象获取命令行参数
        CLIParser *parser = [[CLIParser alloc] initWithCount:argc arguments:argv];
        uint32_t registerValue;
        NSInteger registerByte;
        unsigned int byteValue;
        BOOL isSetByte;
        NSError *error;
        BOOL success = [parser parseWithRegister:&registerValue byteNymber:&registerByte doSetByte:&isSetByte byteValue:&byteValue error:error];
        
        if (!success) {
            // 将错误记录到日志中并退出
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
                return -1;
            }
        } else {
            // 创建一个RegEdit实例并设置它的初始值
            RegEdit *regEdit = [[RegEdit alloc] initWithValue:registerValue];
            NSLog(@"Initial register setting -> 0x%X",(uint32_t)[regEdit regSetting]);
            
            // 使用自定义下标获取选中的寄存器字节
            NSNumber *byte = regEdit[registerByte];
            NSLog(@"Byte %ld value retrieved -> 0x%X",(long)registerByte, [byte intValue]);
            
            // 使用自定义下标将选中的寄存器字节的内容设置为输入值
            if (isSetByte) {
                NSLog(@"Setting byte %d value to -> 0x%X", (int)registerByte, byteValue);
                regEdit[registerByte] = [NSNumber numberWithUnsignedInt:byteValue];
                NSLog(@"Updated register setting -> 0x%X", [regEdit regSetting]);
            }
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
