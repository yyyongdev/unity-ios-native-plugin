# Unity와 IOS 네이티브 플러그인 (Unity - IOS Native Plugin)
### Unity Scene
IOSManager라는 이름의 게임오브젝트와 스크립트가 있고 이벤트를 받을 버튼 2개 생성했다  
Get Battery는 디바이스의 남은 배터리를 가져오는 기능, Open Web Page는 해당 URL을 웹뷰로 여는 기능이며 IOS 네이티브에서 작성된 코드로 동작한다  
   
### Unity C#
[DllImport("__Internal")] 선언으로 IOS네이티브쪽에 extern으로 정의될 함수이름과 매개변수를 적어준다  
IOS쪽에서 실행된 결과를 다시 유니티에서 받을수 있도록 ReceiveFromNativeGetBattery (string msg) 함수도 만들어둔다  
```cs
using UnityEngine;
using UnityEngine.UI;
using System.Runtime.InteropServices;

public class IOSManager : MonoBehaviour
{
    public Text batteryValue;
    public InputField webPageURL;
    
    // Unity to IOS
    [DllImport("__Internal")]
    public static extern void NativeGetBattery();

    [DllImport("__Internal")]
    public static extern void NativeOpenWebPage(string url);

    // IOS to Unity
    public void ReceiveFromNativeGetBattery(string msg)
    {
        batteryValue.text = msg;
    }

    // Button Events
    public void OnButtonGetBattery()
    {
        NativeGetBattery();
    }
    
    public void OnButtonOpenWebPage()
    {
        NativeOpenWebPage(webPageURL.text);
    }
}

```  
  
  
   
### IOS Objective-C
XCode 프로젝트로 빌드를 하고 아래 코드를 적어준다  
extern으로 선언되어있기 때문에 코드어디에 있어도 호출이 되겠지만 여기서는 UnityAppController.mm 파일에 추가해주자  
다시 유니티쪽으로 결과를 보낼때는 UnitySendMessage를 호출하는데 각각의 매개변수는 ("유니티 하이어라키 게임오브젝트이름", "함수이름", "전달할 매개변수값") 이다  
```objectivec
extern "C" {
    void NativeGetBattery()
    {
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        float batLeft = [myDevice batteryLevel] * 100;
        NSString* strBatLeft = [NSString stringWithFormat:@"%f", batLeft];
        
        UnitySendMessage("IOSManager", "ReceiveFromNativeGetBattery", [strBatLeft UTF8String]);
    }

    void NativeOpenWebPage(const char* url)
    {
        NSURL* nsurl = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
        [[UIApplication sharedApplication] openURL:nsurl options:@{} completionHandler:^(BOOL bSuccess){
            NSLog(@"URL open : %@", (bSuccess ? @"success" : @"fail"));
        }];
    }
}
```
  
이제 자신의 IOS 디바이스에 실행을 해보고 버튼을 눌러보면 잘 동작하는 것을 확인 할 수 있다   