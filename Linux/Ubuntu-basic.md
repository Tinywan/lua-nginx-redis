##  [Ubuntu14.04 从安装软件到卸载软件，删除安装包](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Linux/Ubuntu-basic.md)
+   如何安装不知道一个软件的全称？
    +   如果你想安装一个软件。比如：OpenCV库，你可以使用以下命令：
      
        ```bash
        sudo apt-get install libopencv-dev
        ```
    +   那么libopencv-dev这个名字是怎么来的，我只知道我想安装opencv
        +   而直接使用：`sudo apt-get install opencv`是不行的 
        +   正确使用：`apt-cache search opencv`
        +   或者` sudo apt-get install aptitude && aptitude search opencv` 
+   如何知道Ubuntu里安装了哪些软件？列出所有安装的软件：` dpkg -l`
+   如何确切知道自己是否安装了某个软件？
    +   命令1：`dpkg -l filename`
    +   命令2：`dpkg -l "*google*"`使用通配符就可以方便查找了
+   如何卸载某个软件？
    
    ```bash
    sudo apt-get --purge remove <programname> --purge表示彻底删除
    ```
+   如果想删除apt-get下载的某个软件安装包呢？
    +   Ubuntu 中apt-get下载的安装包放在/var/cache/apt/archives里。所以可以在这个路径下删除    
    +   或者使用命令1：`apt-get autoclean`,这个命令将已经删除了的软件包的.deb安装文件从硬盘中删除掉    
    +   或者使用命令2：`apt-get clean `,这会把你已安装的软件包的安装包也删除掉    
  