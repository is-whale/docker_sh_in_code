## docker 图形化
---
此仓库用于启动docker图形化，通过端口转发，将docker的图形化转发到本机

### 使用方法
- 宿主机安装
```
sudo apt-get install x11-xserver-utils
xhost +
```

这两句的作用是开放权限，允许所有用户，当然包括docker，访问X11的显示接口。
- 修改脚本中需要挂载的本机目录、docker镜像
- 启动脚本
- 测试是否成功
在docker中安装
```
sudo apt-get install xarclock #安装这个小程序
xarclock #运行，如果配置成功，会显示出一个小钟表动画
```


