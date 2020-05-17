#pragma mark - call from unity
extern "C" {
    void SendToNativeGetBattery()
    {
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        float batLeft = [myDevice batteryLevel] * 100;
        NSString* strBatLeft = [NSString stringWithFormat:@"%f", batLeft];
        
        UnitySendMessage("IOSManager", "ReceiveFromNativeGetBattery", [strBatLeft UTF8String]);
    }

    void SendToNativeOpenWebPage(const char* url)
    {
        NSURL* nsurl = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
        [[UIApplication sharedApplication] openURL:nsurl options:@{} completionHandler:^(BOOL bSuccess){
            NSLog(@"URL open : %@", (bSuccess ? @"success" : @"fail"));
        }];
    }
}
