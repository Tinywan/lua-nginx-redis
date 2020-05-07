## 如何改进 NGINX 配置文件节省带宽？

#### 为HTML，CSS和JavaScript文件启用Gzip压缩

如您所知，用于在现代网站上构建页面的HTML，CSS和JavaScript文件可能非常庞大。在大多数情况下，Web服务器可以即时压缩这些和其他文本文件，以节省网络带宽。

查看Web服务器是否正在压缩文件的一种方法是使用浏览器的开发人员工具。对于许多浏览器，您可以使用F12键访问这些工具，并且相关信息位于“网络”选项卡上。

![](/Images/screenshot_1588728211136.png)

默认情况下，NGINX中禁用压缩，但是根据您的安装或Linux发行版，某些设置可能会在默认的nginx.conf文件中启用。在这里，我们在NGINX配置文件中启用gzip压缩：
```
gzip on;
gzip_types application/xml application/json text/css text/javascript application/javascript;
gzip_vary on;
gzip_comp_level 6;
gzip_min_length 500;
```

#### 设置缓存头
当浏览器检索网页的文件时，它会将副本保留在本地磁盘缓存中，这样，当您再次访问该页面时，它不必从服务器重新获取文件。每个浏览器都使用自己的逻辑来决定何时使用文件的本地副本以及何时在服务器上更改了文件时再次获取它。但是，作为网站所有者，您可以在发送的HTTP响应中设置缓存控制和过期标头，以提高浏览器的缓存行为的效率。从长远来看，您会收到很多不必要的HTTP请求。

首先，您可以为字体和图像设置较长的缓存过期时间，这些字体和图像可能不会经常更改（即使更改，它们通常也会获得新的文件名）。在以下示例中，我们指示客户端浏览器将字体和图像在本地缓存中保留一个月：

```
location ~* \.(?:jpg|jpeg|gif|png|ico|woff2)$ {
    expires 1M;
    add_header Cache-Control "public";
}
```
#### 启用HTTP / 2协议支持
HTTP / 2是用于服务网页的下一代协议，旨在更好地利用网络和主机服务器。根据Google文档，它可以更快地加载页面：

生成的协议对网络更友好，因为与HTTP / 1.x相比，使用的TCP连接更少。这意味着与其他流量的竞争减少，连接寿命更长，从而可以更好地利用可用网络容量。

NGINX 1.9.5和更高版本（以及NGINX Plus R7和更高版本）支持HTTP / 2协议，您所需要做的就是启用它。为此，请在您的NGINX配置文件中http2的listen指令中包含参数：

```
listen 443 ssl http2;
```
请注意，在大多数情况下，您还需要启用TLS才能使用HTTP / 2。

您可以通过[HTTP2.Pro](https://http2.pro/) 服务验证您（或任何站点）是否支持HTTP / 2 ：


#### 优化记录
让自己喝一杯自己喜欢的饮料，舒适地坐着，然后思考：您上次查看访问日志文件是什么时候？上周，上个月，从来没有？即使将其用于站点的日常监视，您也可能只关注错误（400和500状态代码等），而不关注成功的请求。

通过减少或消除不必要的日志记录，可以节省服务器上的磁盘存储，CPU和I / O操作。这不仅使您的服务器更快一点-如果将您部署在云环境中，则释放的I / O吞吐量和CPU周期可能为同一虚拟机上的其他虚拟机或应用程序节省生命。

有几种不同的方法可以减少和优化日志记录。在这里，我们重点介绍三个。


##### 方法1：禁用页面资源请求的记录

如果您不需要记录检索普通页面资源（例如图像，JavaScript文件和CSS文件）的请求，则这是一种快速简便的解决方案。您需要做的就是创建一个location与这些文件类型匹配的新块，并禁用其中的日志记录。（您也可以将此access_log指令添加到我们设置标头的上方的location块中。）Cache-Control
```
location ~* \.(?:jpg|jpeg|gif|png|ico|woff2|js|css)$ {
    access_log off;
}
```
##### 方法2：禁用成功请求的日志记录

这是一种更强大的方法，因为它会丢弃带有或响应代码的查询，仅记录错误。它比方法1稍微复杂一点，因为它取决于如何配置NGINX日志记录。在我们的示例中，我们使用Ubuntu Server发行版中包含的标准**nginx.conf**，因此，无论虚拟主机如何，所有请求都记录到 **/var/log/nginx/access.log中**。`2xx``3xx`

使用[官方NGINX文档中](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log)的示例，让我们打开条件日志记录。创建一个变量`$loggable`，并将其设置为，`0`以使用和代码进行请求，否则设置为 。然后在指令中将此变量作为条件引用。`2xx``3xx``1``access_log`

这是 **/etc/nginx/nginx.conf** 中`http`上下文中的原始指令：
```
access_log /var/log/nginx/access.log;
```
添加一个[`map`](https://nginx.org/en/docs/http/ngx_http_map_module.html#map)块并从`access_log`指令中引用它：

```
map $status $loggable {
    ~^[23] 0;
    default 1;
}

access_log /var/log/nginx/access.log combined if=$loggable;
```
请注意，尽管这`combined`是默认的日志格式，但是在包含`if`参数时，您需要明确指定它。

##### 方法3：使用缓冲最小化I / O操作

即使您要记录所有请求，也可以通过打开访问日志缓冲来最大程度地减少I / O操作。使用此指令，NGINX会等待将日志数据写入磁盘，直到填满512 KB缓冲区或自上次刷新以来经过1分钟（以先发生者为准）。

```
access_log /var/log/nginx/access.log combined buffer=512k flush=1m;
```

### 限制特定URL的带宽

如果服务器提供较大的文件（或较小但非常受欢迎的文件，例如表单或报表），则设置客户端下载文件的最大速度可能很有用。如果您的站点已经承受了很高的网络负载，则限制下载速度会留下更多带宽，以使应用程序的关键部分保持响应速度。这是硬件制造商使用的非常流行的解决方案–您可能需要等待更长的时间才能为打印机下载3 GB的驱动程序，但是同时有成千上万的其他人下载您仍然可以下载。😉

使用[`limit_rate`](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate)指令限制特定URL的带宽。在这里，我们将 **/ download** 下每个文件的传输速率限制为每秒50 KB。
```
location /download/ {
    limit_rate 50k;
}
```
您可能还希望仅对较大的文件进行速率限制，这可以使用[`limit_rate_after`](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_rate_after)指令进行。在此示例中，每个文件（来自任何目录）的前500 KB都不受速度限制地进行传输，之后的所有内容均以50 KB / s为上限。这样可以加快网站关键部分的交付速度，同时降低其他部分的速度。

```
location / {
    limit_rate_after 500k;
    limit_rate 50k;
}
```
请注意，速率限制适用于浏览器和NGINX之间的单个HTTP连接，因此请不要阻止用户使用下载管理器来解决速率限制。

最后，您还可以限制到服务器的并发连接数或请求速率。有关详细信息，请参见我们的[文档](https://docs.nginx.com/nginx/admin-guide/security-controls/controlling-access-proxied-http/)。