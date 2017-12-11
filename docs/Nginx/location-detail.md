##  location 详解

####  匹配顺序

* location 的匹配顺序其实是**“先匹配普通，再匹配正则”**。

* * 正则匹配会覆盖普通匹配（实际的规则，比这复杂）  

####  执行顺序

* “普通 location ”的匹配规则是“最大前缀”，因此“普通 location ”的确与 location 编辑顺序无关。

* “正则 location ”的匹配规则是“顺序匹配，且只要匹配到第一个就停止后面的匹配”。

* 两种情况下，不需要继续匹配正则 location

  * （1）当普通 location 前面指定了`^~ `，特别告诉 Nginx 本条普通 location 一旦匹配上，则不需要继续正则匹配。
  * （2）当普通location 恰好严格匹配上，不是最大前缀匹配，则不再继续匹配正则。

* 正则 location 匹配让步普通 location 的严格精确匹配结果；但覆盖普通 location 的最大前缀匹配结果。     

####  官方文档

* 语法
  ```bash
  location
  syntax: location [=|~|~*|^~|@] /uri/ { … }
  default: no
  context: server
  ```
* 正则location `（location using regular expressions）`
  * `~` 和 `~*` 前缀表示正则location
  * `~` 区分大小写
  * `~*` 不区分大小写
* 普通location `（location using literal strings）`
  * 无任何前缀的都属于普通 location
  * 其他前缀（包括：`=`、`^~` 和 `@`）也属于普通匹配
* 对于特定的HTTP请求`（a particular query）`,`nginx`应该匹配哪个`location`块的指令
  * 原文：`To determine which location directive matches a particular query, the literal strings are checked first.` 先普通location再正则location
* `普通location` 与 `普通location` 是如何匹配的？
  * 匹配规则1：先匹配普通location，再匹配正则location
  * 匹配规则2：最大前缀匹配
  * 匹配规则3：匹配`URI`的前缀部分`(match the beginning portion of the query)`
  * 匹配规则4：最具体的匹配将被使用`(the most specific match will be used)`，因为 location 不是`严格匹配`，而是`前缀匹配`，就会产生一个HTTP 请求，可以`前缀匹配`到多个普通location
  * 案例
    * 列如：`location /prefix/mid/ {} `和`location /prefix/ {}` 
    * 于HTTP 请求`/prefix/mid/t.html`，前缀匹配的话两个`location`都满足，该匹配哪个？
    * 匹配原则：最具体匹配原则`the most specific match`
    * 最后的匹配是：`location /prefix/mid/ {}`
* `正则location` 与 `正则location` 是如何匹配的？
  * 匹配规则是：按照 **正则location** 在配置文件中的物理顺序（编辑顺序）匹配
  * 注意1：`location` 并不是一定跟顺序无关，只是**普通 location**与顺序无关，**正则 location**还是与顺序有关的
* `正则location`和`普通location`最大匹配如何匹配？
  * 正则：**只要匹配到一条正则location ，就不再考虑后面匹配**
  * 普通：**选择出“普通location”的最大前缀匹配结果后，还需要继续搜索正则location**
* `(普通)`最大前缀匹配结果与继续搜索的`正则location`匹配结果的决策关系
  * 原文：`If no regular expression matches are found, the result from the literal string search is used.` 如果找不到正则表达式匹配，则使用文字字符串搜索的结果
  * 匹配一：如果继续搜索的`正则location`也有匹配上的，那么`正则location`覆盖`普通location`的最大前缀匹配。
  * ~~因为有这个覆盖关系，所以造成有些同学以为正则location 先于普通location 执行的错误理解~~ 
  * 但是如果“正则location ”没有能匹配上，那么就用“普通location ”的最大前缀匹配结果
* 一般匹配原则
  * 匹配完了`普通location`指令，还需要继续匹配`正则location`
  * 也可以告诉Nginx：匹配到了`普通location`后，不再需要继续匹配`正则location`了，  
    >1.要做到这一点只要在`普通location`前面加上`^~`符号  
    >2.`^` 表示`非`，`~` 表示`正则`，字符意思是：`不要继续匹配正则`
  * `^~`和`=` 区别
    * 共同点：都能阻止继续搜索`正则location` 
    * 不同点：
      >1.`^~`依然遵守`最大前缀`匹配规则
      >2.`=`不是`最大前缀`，而是必须是严格匹配（exact match ）

### 继续...

