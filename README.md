#  README

## RSSI 扫频算法设计

### RSSI分布描述

<img src="../MMC/docs/pic/扫频算法描述.png" alt="image-20220626145138666" style="zoom:33%;" />

该图为频率范围$f\in[87MHz,108MHz]$下的RSSI的对数坐标分布$RSSI_{log}=10\times\log{RSSI}$。

此设计的目的是**利用编写的接口函数，筛选出图中标出的频点**。

### 需求描述

#### 输入

##### RSSIType

上图中对应的RSSI数据存放在下述定义的数据结构中：

```c
typedef struct{
    int index;	//存放每个采样点的索引值
    int RSSI;	//存放RSSI的值
}RSSIType;
```

❤**注意此处的RSSI不是图中所示的对数形式，请不要对RSSI的值进行Log运算（尽量不要进行任何运算，因为数据量大，延迟很高）。**

构成结构数组定义如下：

```C
#define NUM 1060
#define STEP 0.02
RSSIType rssilist[NUM];
```

不推荐更改`NUM`（数组长度设定为1060）和`STEP`（扫频步长设定为0.02MHz）的数值。由于不可名状的BUG，在第一次运行扫频函数时，`rssilist[0]`的RSSI值为0。因此可以使用的数据为`rssilist[1]`~`rssilist[1050]`共1050个RSSIType数据结构。（由于C的浮点数特性，导致频率为108时仍然可以运行扫频程序，因此会比期望的数量多一个）

##### 门限值Thresh

`RSSI>Thresh`时对应的频率才可能成为频点，**但若该门限过低，导致输出的频点多于16个时，仅输出最高的16个。**

#### 输出

观察数据规律，输出RSSI值最高的频点（**精度要求为0.1MHz**），将所有频点的频率**从小到大**存放在以下数据结构中。

```C
 typedef struct{
    unsigned int  channel_no; //存放频道号，从1开始递增编号
    float  freq;		      //存放频点频率
    unsigned int  INT;		  //存放整数部分
    unsigned int  FRAC;		  //存放小数部分
}ChannelControlType;
```

其中`INT`和`FRAC`与频率的转换公式如下：

```C
int INT=floor(freq/3);
int FRAC=(freq/3-INT)*3000;
```

**可以使用提供的数据在x86平台进行测试，测试完毕后需要按照注释的位置插入相应的代码，并Build确认无报错**。

需要插入的部分包括：

`code_def.h`第73行声明函数名；

`code_def.c`第13行创建ChannelControlType数组（含有16个元素）全局变量；

`code_def.c`第239行调用函数；

`code_def.c`第246行完成函数构建。



