//
//  CLIParser.m
//  New-project_23-RegEdit
//
//  Created by Geraint on 2018/5/7.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import "CLIParser.h"
#import "RegEditConstants.h"


NSString *HelpCommand = @"\n RegEdit -n [Hex initial register setting] -b [byte number] -v [hex byte value]";
NSString *HelpDesc = @"\n\nNAME\n RegEdit - Get/set selected byte of a register.";
NSString *HelpSynopsis = @"\n\nSRNOPSIS";
NSString *HelpOptions = @"\n\nOPTIONS";
NSString *HelpRegValue = @"\n -n\tThe initial register setting.";
NSString *HelpRegByte = @"\n -b\tThe byte to sretrieve from the register.";
NSString *HelpByteValue =@"\n -v\tValue to set for the selected register byte.";

@implementation CLIParser

// 私有实例变量
{
    const char **argValues;
    int argCount;
}

- (id) initWithCount:(int)argc arguments:(const char *[])argv  {
    if (self = [super init]) {
        argValues = argv;
        argCount = argc;
    }
    return self;
}

- (BOOL) parseWithRegister:(uint32_t *)registerValue
                byteNymber:(NSInteger *)byteN
                 doSetByte:(BOOL)diSet
                 byteValue:(unsigned int *)byteValue
                     error:(NSError *)anerror {
    // 使用NSUserDefaults类获取命令行参数
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *numberString = [defaults stringForKey:@"n"];
    NSString *byteString = [defaults stringForKey:@"b"];
    NSString *valueString = [defaults stringForKey:@"v"];
    
    // 如果用户没有提供寄存器值或字节数，就显示帮助信息
    if (!numberString || !byteString) {
        NSString *help = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", HelpDesc, HelpSynopsis, HelpCommand, HelpOptions, HelpRegValue, HelpRegByte, HelpByteValue];
        printf("%s\n", [help UTF8String]);
        return NO;
    }
    
    // 检查输入的寄存器值
    NSString *scanner = [NSScanner scannerWithString:numberString];
    if (!numberString || ([numberString length] == 0) || ([numberString length] > kRegisterSize*2) || ![scanner scanHexInt:registerValue]) {
        // 创建出错误实例并返回NO
        if (anerror != NULL) {
            NSString *msg = [NSString stringWithFormat:@"ERROR!, Register value must be from 1-%ld hexadecimal characters",kRegisterSize*2];
            NSString *description = NSLocalizedString(msg, @"");
            NSDictionary *info = @{NSLocalizedDescriptionKey:description};
            int errorCode = 1;
            NSError *anerror = [NSError errorWithDomain:@"CustomErrorDomain" code:errorCode userInfo:info];
        }
        return NO;
    }
    
    // 检查输入的寄存器字节数
    scanner = [NSScanner scannerWithString:byteString];
    if (!byteString || ([byteString length] == 0) || [scanner scanInteger:byteN]) {
        unsigned int numberLength = (unsigned int)(ceil([numberString length] * 0.5));
        if ((*byteN < 0) || (*byteN > (numberLength - 1))) {
            // 创建出错实例并返回NO
            if (anerror != NULL) {
                NSString *msg = [NSString stringWithFormat:@"ERROR!, Register byte number must be from 0-%ld",numberLength-1];
                NSString *description = NSLocalizedString(msg, @"");
                NSDictionary *info = @{NSLocalizedDescriptionKey:description};
                int errorCode = 2;
                NSError *anerror = [NSError errorWithDomain:@"CustomErrorDomain" code:errorCode userInfo:info];
            }
            return NO;
        }
    }
    
    // 检查用于设置寄存器字节内容的输入值
    if (valueString) {
        BOOL doSet = YES;
        scanner = [NSScanner scannerWithString:valueString];
        if ([scanner scanHexInt:byteValue]) {
            if (*byteValue > UCHAR_MAX) {
                if (anerror != NULL) {
                    NSString *msg = [NSString stringWithFormat:@"ERROR!, Register byte value must be 1-2 hexadecimal characters"];
                    NSString *description = NSLocalizedString(msg, @"");
                    NSDictionary *info = @{NSLocalizedDescriptionKey:description};
                    int errorCode = 3;
                    NSError *anerror = [NSError errorWithDomain:@"CustomErrorDomain" code:errorCode userInfo:info];
                }
                return NO;
            }
        }
    }
    
    return YES;
}
@end
