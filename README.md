# buildScript

分为两个脚本
  1.framework合并脚本 “framework.sh”
    脚本嵌入xcode中runscript中，可将编译好的真机，和模拟器framework 合成一个，输出到framework的项目文件目录 build 文件夹下
  2.lib静态库脚本 “libIncludePods.sh”
    主要用作在cocoapods管理下，有时需要将cocoapods管理下的第三方打包到lib静态库中，而此脚本解决了，将pod管理下的第三方，打包到静态库的工能，放在xcode 的runscript中，输出是，各个架构的包含第三方的.a文件在lib项目的目录build中展示。

