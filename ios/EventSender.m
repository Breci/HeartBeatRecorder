//
//  EventSender.m
//  IRUS_V4
//
//  Created by CULAS Brice on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//
#import "EventSender.h"


@implementation EventSender
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(notifyReact){
  printf("hello\n");
  [self sendEventWithName:@"end_recording" body:@{@"data": @[@0.3,@1.5]}];
}

RCT_EXPORT_METHOD(setBridge){
  printf("bridge set\n");
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"end_recording",@"test",@"start_waiting",@"start_initializing",@"start_recording", @"return_words"];
}

@end
