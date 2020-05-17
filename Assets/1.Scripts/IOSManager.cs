using UnityEngine;
using UnityEngine.UI;
using System.Runtime.InteropServices;

public class IOSManager : MonoBehaviour
{
    public Text batteryValue;
    public InputField webPageURL;
    
    // Unity to IOS
    [DllImport("__Internal")]
    public static extern void SendToNativeGetBattery();

    [DllImport("__Internal")]
    public static extern void SendToNativeOpenWebPage(string url);

    // IOS to Unity
    public void ReceiveFromNativeGetBattery(string msg)
    {
        batteryValue.text = msg;
    }

    // Button Events
    public void OnButtonGetBattery()
    {
        SendToNativeGetBattery();
    }
    
    public void OnButtonOpenWebPage()
    {
        SendToNativeOpenWebPage(webPageURL.text);
    }
}
