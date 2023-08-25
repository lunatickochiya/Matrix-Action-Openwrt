
# luci-cifs-app
###### Mounting NAT drives

![](http://ww4.sinaimg.cn/large/6c12375ejw1f25g9faos5j213h0p0n0m.jpg)

### Options

* General Settings

    * Workgroup
    > 
    Input: workgroup name
    > 
    default: WORKGROUP

    * Mount_Area
    > 
    Input: Path
    > 
    default: WORKGROUP
    > 
    All the Mounted NAT Drives will be centralized into this folder.

    * *Delay*
    > 
    Iput: number(s)
    >
    This option set up to delay command runing for wait till your drivers online.
    Specially for those who using WLAN.
    >
    Only work in start mode(/etc/init.d/cifs start) 

    * Iocharset
    >
    Character Encoding.


* NAT Drivers

    * Server
    > 
    Input: server domain or server ip address.
    
    * Mouting Folder Name
    > 
    Input: A Folder NAT driver will be mounted.
    >
    Single NAT driver mounting folder name.
    
    * NatPath
    >
    Input: A NAT driver location.
    
    * Arguments
    >
    Input: Arguments you need to add.(rw,nounix,etc..)
    
    * Using Guest
    >
    Input: Select to using guest.
    
    * Users
    >
    Input: Users name
    
    * password
    >
    Input: Users password.
    
