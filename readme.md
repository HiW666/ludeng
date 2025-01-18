### 慧芯耀乡,智灯启梦

1
随着社会脚步的不断前行，民众的生活质量也在不断地提高，服务于乡村生活的各项设施都在不断地更新，并且数量也在不断地增加，
但如今大多数生活服务设备都集中在城市，乡村服务项目存在类型单一、分布零散、处理故障滞后等问题，缺乏有效的控制手段且无统一的管理系统。
因此我们推出了基于5G的数字乡村智慧路灯管理系统。
针对数字乡村智慧路灯设计缺失、资源统筹不足、基础设施薄弱、区域差异明显、设施单一、监控管理方式落后且维护成本高等问题，
基于JAVA和Android等技术搭建网页系统，基于单片机技术搭建智能检测装置，联合NB-IOT网络、5G网络以及云平台，
我们研发出一套数字乡村智慧路灯管理系统，以实现数字乡村路灯统一智能化管理，能够实时采集影响环境信息、数字乡村智慧路灯设施、装置等状态数据，
及时、准确地展示乡村公共能源设施状态，为政府提供智能管理与数据分析。

### 软件管理系统功能
软件管理系统，分为Web前端和移动app端，由资产管理子系统，运营管理子系统、故障处理子系统和辅助管理子系统等组成。
资产管理子系统负责数字乡村公共能源设施设备基础数据的录入和导出并通过GPS定位技术，通过图形化手段，将设备资产按实际情况反映在系统电脑界面上；
运营管理系统负责数字乡村公共能源设施控制管理、能耗管理，即在数字乡村公共能源设施实际运营维护和管理过程中，通过对数字乡村公共能源设施的智能控制，以及结合后期综合评价分析结果调整使用策略，降低数字乡村公共能源设施能耗最终以实现数字乡村公共能源设施节能；
故障处理子系统负责数字乡村公共能源设施故障分析报警，通过移动应用软件（APP）在移动终端上实现对数字乡村公共能源设施控制的各种维修操作，实现从派工、现场施工到完工报告的流程化管理、海量数据管理；辅助管理子系统负责员工管理、区域管理。如表2所示，为软件功能清单。
2
### 代码的目录结构：

慧芯耀乡,智灯启梦
├── jie-deng
│   └── Pods
├── lds_backend
│   ├── core
│   ├── src
│   └── target
└── lds_manager
    ├── mock
    ├── plop-templates
    ├── public
    ├── src
    └── tests


### 系统设备列表

设备的状态都可以在web网页上看到，如果正常运行，设备状态显示正常，如果出现异常循环系统会监测到，
由主控发送到AT指令至NB-IOT模组，再上传至云服务器中，最后呈现在WEB网页上，设备状态可以一目了然，实现对数字乡村公共能源设施的远程巡检。如图20所示，为Web端系统设备列表。



### 数据状态指标
数据状态指标中，是不同时间段的灯式指标，越高表示在这个段出故障概率越大。如图21所示，为数据状态指标。


### 移动APP终端
移动APP终端的现实界面与Web端一致，信息同步。设备列表情况如图23所示，故障信息情况如图24所示，数据状态指示如图25所示，历史数据如图26所示。
