---
layout: post
title: 2014-03-19-手Q群查找README.md
---

### 打开readme文件的同学，如果本机没有安装markdown相关的查看编辑器可以选用在线版： https://stackedit.io/
# QQ QUN FIND mobile

接口人： materliu,rehornchen

## Documentation

### relational link
[前台wiki][1] 一般以README.md文件为准，内网wiki算是个摆设了

[CGI Wiki][2]

[Moniter 视图][3]

[performance 视图][4] 选择外部门业务-R1平台研发系统-我的QQ中心

[mm上报系统视图][5]  上报是5分钟实时，告警大概是5-10分钟延迟  页面展示会大概15分钟

[伯努利上报系统视图][6]

[dc上报系统视图][10]

[dc 群数据的上报格式](http://dc.dt.oa.com/dcreports/edit?dcid=dc00141&timestamp=1395555959)

[本地构建工具grunt学习][7]

[图片压缩服务][8]

[移动web项目前端上线前检查项](https://docs.google.com/spreadsheets/d/1J7cFLKONZdkfi4ZeETwCceGfu5pryO__1bAtglqVcUg/edit#gid=0)

[项目svn地址-trunk](http://tc-svn.tencent.com/bapp/bapp_connect_rep/qun_search_proj/trunk)

### 快速上手

#### 项目说明

手Q查找使用了grunt这一自动构建工具， CSS使用Sass和Compass来进行组织。目录结构如下：


如图所示:

* doc目录下存放所有的规范类文档；
* dist目录是grunt生成的处理后的代码目录，不需要主动编辑；
* test是自动化测试目录，现在尚未加入，预留功能；
* node_modules目录是grunt等相关编译工具存放目录；所有的逻辑代码存放于app目录。

根目录下的几个文件：

* .jshintrc  jshint 代码检测的配置文件
* bower.json bower 的配置文件， 暂时未用到(2014/02/26)
* config.json 我们自己的发布系统的配置文件， 在其中规定哪个文件发布到哪里
* config.rb  compass 的配置文件
* Gruntfile.js grunt 的配置文件
* p          我们在测试环境上部署代码需要的脚本文件
* package.json 整个项目其实相当于一个大的nodejs项目，package.json规定了这个nodjs项目用到的所有node_modules
* README.md  项目的说明文件， 就是你当前正在读的这个文件
* app/robots.txt 通过其中的内容，我们限制搜索引擎索引我们的页面

#### 本地环境搭建
* sass和compass  sass和compass依赖于ruby环境，需要安装ruby运行时，windows平台下推荐： [RubyInstaller][9], 之后再命令行中 执行 gem install sass，gem install compass 安装sass和compass，  当然公司内网有时候需要加上  gem install sass --http-proxy=https://proxy.tencent.com:8080 你懂的
* grunt 需要本地有nodejs环境， 这个不用多说了， 在命令行执行： npm install -g grunt-cli  进行安装
* cgi路径为：qun.qq.com/cgi-bin/
* 前台页面路径为： qun.qq.com/search/mobileqq/index.html    qun.qq.com/search/mobileqq/index.html

前台页面路径和cgi路径在同一个域名下这就给我们配置测试环境带来了一定的困扰，

materliu现在的解决方案是：在我们的测试机上，比如说156， 额外配置一条规则, 把 qun.qq.com/cgi-bin/的请求转发到对应的cgi测试机器上

        upstream qun_test1_env {
            server 10.134.6.108:80;
        }
        upstream qun_test2_env {
            server 10.153.148.141:80;
        }
        server {
            include common/*.conf;
            server_name qun.qq.com;
            root /data/sites/qun.qq.com;

            ssi on ;
            ssi_silent_errors on;
            ssi_types text/shtml;

            location ~ \.html$
            {
                expires  0s;
            }

            location /cert/ {
                proxy_set_header    Host "qun.qq.com";
                proxy_redirect   off;
                rewrite ^/cert/cgi-bin/(.*) /cert/cgi-bin/$1 break;
                proxy_pass http://qun_test1_env;
            }

            location /cgi-bin/ {
                proxy_set_header    Host "qun.qq.com";
                proxy_redirect   off;
                rewrite ^/cgi-bin/(.*) /cgi-bin/$1 break;
                proxy_pass http://qun_test1_env;
            }
        }

#### 跑起来
* 我们有一个分支是用来存放，所有的grunt依赖到的插件的nodejs包的，分支地址： http://tc-svn.tencent.com/bapp/bapp_connect_rep/qun_search_proj/branches/qun_search_m_node_modules

* 从trunk拉开发分支，或者直接在trunk上开发（如果有必要），这里注意把此工作分支文件目录跟上边的nodejs包分支放于同一级目录内  比如说： workspace /  qqfind_mobile_node_modules  trunk

* 本地访问方法： 直接使用fiddler代理，将qun.qq.com/search/mobileqq/ 的请求指向本地项目目录。

* 本机环境配置

    1. 电脑配置无线网卡连接FreeWifi，ipconfig查询IP为A（10.66.**.**）
    2. 手机配置A，端口为B（如：8080）。
    3. Fiddler配置Tools->Fiddler Options->Connections:

        勾选Allow remote computers to connect

        Fiddler listens on port: 填写B

    4. 确认可以访问，注意Fiddler左下角状态为capturing
    5. 背景： 本地化——_bid=118

        打包到手Q4.6安装包，IOS采取的包较小约9K（框架本地化，保证加入群搜索框OK），Android的包较大约28K（几乎全部本地化，除base64的图片外其他是网络图片）。

        具体本地化策略、实践及权限可联系yukinzhang

        因为手Q默认打包了群查找页面的zip包到安装包内，第一次使用群查找的时候，会释放出来，释放到目录/tencent/MobileQQ/qbiz/html5/118，所以导致我们始终无法访问到线上或是配置到本机的代码，做法是通过应用宝定位到这个目录 在/tencent/MobileQQ/qbiz/html5/下上传一个命名为118的文件，这样就创建不了了，可以访问线上版本。

        ios替换这个文件的做法则需要使用 ifunbox -> 管理App数据 -> 所有应用程序 -> QQ CI

        目录是Documents/webappCache2/118 QQ.app目录内的内容无法改动，是加了苹果签名的内容。
    6. 那测试是如何进行的呢？ 我们把开发代码发布到测试环境，然后发一个空的zip包到 [测试环境](http://admin.connect.oa.com/index.html)  发的时候记得选择灰度，把开发，测试，产品等相关人的uin加进去，格式如下： [{"min":1123944850,"max":1123944850}]

* 部署测试环境访问： 在命令行中执行 grunt 完成代码发布前的编译工作，提交svn， 登陆测试环境机器，登陆方法：我们现有5台测试机器
    10.12.23.156
    10.12.23.157
    10.12.23.158
    10.12.23.159
    10.12.23.163
端口号使用 36000 账号是***  密码是： pass4devne****
登陆上去以后，进入 /data/frontend/qqfind_mobile ,将当前项目checkout下来， 进入项目目录， 在项目目录下执行编译部署脚本p
    chmod 777 p
    ./p 0|1|2|3|4   后边的参数分别对应机器 156,157,158,159,163，比如像部署到 156机器，执行./p 0

#### 发布流程

#####先ARS预编译：
http://pub.qplus.oa.com/html/ars_precompile.php
svn： 贴入当前要发布的tag的svn地址， 记得是https开头的
发布域名选择 QQ群 qun.qq.com
cdn发布路径选择  qqun
编译说明： 此次发布的原因

得到类似地址：
/data/sites/cdn.qplus.com/qqfind/m/js/find.js
/data/sites/cdn.qplus.com/qqfind/m/index.html

进入ARS发布系统：
http://ars.isd.com/

1.类目选择：发布请求-免测版本发布
2.产品选择：开放平台 模块选择：公共平台 其他如版本号等可任意填写
3.编译机选择 220机器
3.把预编译得到的地址 粘贴到发布内容
4.下一部处理人选择： 测试童鞋的rtx，如alanqing
5.提交后知会测试


[zip包发布](/all/tencent/2014/04/15/mobile_qq_zip_publish.html)


### 介入开发
#### 代码规范
+ 首先参考 [alloyteam代码规范](http://materliu.github.io/code-guide/)
+ 上报代码 任何一个页面，对于点击上报数据只监听 [data-report-dc] 属性选择器， 有此属性选择器，则取其值进行dc上报， data-report-dc的格式如下：data-report-dc-str="opername=Grp_tribe,module=join_list,action=Clk_recom,ver1={{banner.bid}}" 具体代码参考如下：

```javascript
   /**
    * 根据以逗号分隔的str约定的参数，上报dc
    * str 不需要包含客户端版本， 当前用户的uin 以及时间戳
    * @param str
    */
   function reportDCStr(str) {

       var oneDimensionsArr = str.split(","),
           twoDimensionsArr = [],
           reportObj = {};

       oneDimensionsArr.forEach(function (value) {
           twoDimensionsArr.push(value.split("="));
       });

       for (var i= 0,j=twoDimensionsArr.length; i<j; i++) {
           for (var k= 0,innerObj=twoDimensionsArr[i],l=innerObj.length; k<l; k++) {
               reportObj[innerObj[0]] = innerObj[1];
           }
       }

       reportObj['ts'] = new Date() - 0;
       reportObj["obj2"] = $.version;
       reportObj['uin'] = $.cookie.getUin();

       report.tdw(reportObj, true);
   }


   // 这里为什么不能简单用click， 因为click事件在iphone上没有冒泡 参见注意点事项
   // 需要在希望冒泡的元素上，如果非a标签，需要添加响应的css属性
   // cursor: pointer;     -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
   document.addEventListener("touchend", function (event) {

       var target,
           reportTarget,
           dataReportDCStr;

       try {
           target = event.target,
           reportTarget = $(target).closest("[data-report-dc-str]"),
           dataReportDCStr = reportTarget.attr("data-report-dc-str");
       } catch (e) {
           return;
       }

       if (dataReportDCStr) {
           reportDCStr(dataReportDCStr);
       }

       event.stopPropagation();
   }, false);
```

+ 管理后台
    如果需要修改管理后台的数据配合测试， 需要配置host进行
    + 测试环境管理后台 10.136.149.161 test.connadmin.oa.com
    + 正式环境管理后台 10.133.2.209 connadmin.oa.com
    管理后台的权限申请找 cannonfang



#### 学习资料
* 首先需要学习了解handlebars模板的写法， 页面中所有的模板使用handlebars构建，参见目录 scripts/template/handlebars
    关于handlebars 和 jade 模板如何在客户端预编译使用，可以参见另外两篇博文
    [jade模板预编译][16]
    [handlebars模板预编译][17]

* 何俊关于移动专门输出的学习资料，请新加入同学务必查看 http://www.ipresst.com/play/5334769224c6b1097d002c4a

* Android, iOS 用户分布情况，zip包使用率等数据 参见svn内手Q群部落数据分析-zip包铺量速度.xls

* 客户端统计的zip包的下载成功率等[数据](http://compass.oa.com/auto_plain?reportId=503148&productId=-300005&auth_cm_com_ticket=4156de62-a42d-426c-b3d6-aebdcbf414da)

#### 业务资料
* 群分类，一共分为三级， 第一级比如热门游戏， 第二级比如腾讯游戏， 第三级比如英雄联盟 格式如： [app/data_models/categories.js](/attachments/2014-03-19-categories.js)

#### 各机型适配经验，[参见](/all/tencent/2014/04/14/mobile_web_adapter_experience.html)

##### 手Q客户端接口的调用
内网有官网指定了手机QQ WEB UI 规范， 手机QQ JS API文档， AlloyKit移动Web+中断整体解决方案，[访问][13]
[通过url参数控制QQWebViewController的UI展示使用文档][14]
[手机QQ页面本地化使用说明](/attachments/手机QQ页面本地化使用说明.doc)

##### old_data 目录内容说明
scripts
    public
        myConsole-2014-3-26.js 去掉这个文件的引用， 改用error-report.html



### 注意点
* 手Q客户端本身实现了zip包缓存的机制，这会对我们的日常的开发带来一定的干扰，手Q会发起一条cgi，询问 http://s.p.qq.com/pub/check_bizup  是否有更新的zip包， 把这条请求404， 手Q客户端就会一直从web上拉取页面。  前提是先清空之前已经拉下来的zip包。


* 同步网络资源，无需很频繁，这主要是针对低端机型无法更新本地包的情况


* 手Q4.7开始 使用了QQ浏览器提供的webView SDK， 这就会导致手Q4.7使用的webview中webkit内核的版本可能跟当前用户所使用的系统的webview的webkit的版本不同

最蛋疼的是这里还有一个容易出问题的逻辑：

materliu(刘炬光) 03-26 16:58:52

清除应用数据 第一次进去使用的系统webview ？

materliu(刘炬光) 03-26 16:59:02

之后进入就使用的 x5 webview？

cokesu(苏可) 03-26 16:59:41

@materliu(刘炬光) ，是这样的逻辑，因为DEX OPT比较耗时，容易导致ＡＮＲ，所以第一次进会切为系统WebView


* 利用系统提供的删除应用数据， 并不能清除zip包缓存

* 圆角规范稍后我会更新上规范网站  现在是这样   128px以上 圆角大小12px     100px图标圆角大小10px  99px-60px图标 圆角大小6px  小于60px图标圆角4px

* [iphone上的click事件没有冒泡](http://www.quirksmode.org/blog/archives/2010/09/click_event_del.html) [stackoverflow上关于此问题的讨论](http://stackoverflow.com/questions/3705937/document-click-not-working-correctly-on-iphone-jquery)

* zip包机制存在问题， 导致有些页面无法得到更新
    ios上的缓存问题，基于目前的现状，有没有办法做更多处理，减少被缓存或不更新的几率呢？
    不是每个人都知道这个问题，即便知道的人也未必认为ios有问题，更多时候是我们很被动，是离线包下载了, 但是没应用
        <meta http-equiv="cache-control" content="max-age=0" />
        <meta http-equiv="cache-control" content="no-cache" />
    一开始的html头部就加上这两个，因为zip包拦截返回的文件http header里边没有缓存控制信息，导致有些文件被cache在浏览器cache中， ios如此

* 现在webserver和cdn的发布路径之间是存在一定关系的，比如说我们的webserver路径是 qun.qq.com/search/mobileqq/index.html
那cdn路径就得是：pub.idqqimg.com/qqun/search  对应webserver ： qun.qq.com/search  tag名字也有一定要求需要是 qqun_search_timestamp  或者 search_timestamp  别问为什么，运维同学就是这么约定的

### 历来需求单地址
* [【手Q群查找】热门分类关键词增加二级分类](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071055990608)

* [【管理后台】手Q查找运营管理后台](http://tapd.oa.com/v3/qqsearch_web/prong/stories/view/1010063621055938404)

* [【群部落】查找入口群部落展示优化](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071056058807?url_cache_key=6dbc8adcabba2d0d9856066727a1c324)

* [【查找入口】手Q查找二级分类打通](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071056076972?url_cache_key=746bd545a914162f83e18527c9db79b6&action_entry_type=story_tree_list)

### 发布时间记录
* 2014-03-28 14:50 zip 包
    * 关联需求
        * [【手Q群查找】热门分类关键词增加二级分类](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071055990608)
        * [【管理后台】手Q查找运营管理后台](http://tapd.oa.com/v3/qqsearch_web/prong/stories/view/1010063621055938404)


* 2014-04-02 12:05 zip 包
    * 关联需求
        * [【群部落】查找入口群部落展示优化](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071056058807?url_cache_key=6dbc8adcabba2d0d9856066727a1c324)


* 2014-04-04 17:05 web版本
    * 关联需求
        * [【手Q群查找】热门分类关键词增加二级分类](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071055990608)
        * [【管理后台】手Q查找运营管理后台](http://tapd.oa.com/v3/qqsearch_web/prong/stories/view/1010063621055938404)
        * [【群部落】查找入口群部落展示优化](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071056058807?url_cache_key=6dbc8adcabba2d0d9856066727a1c324)


* 2014-04-08 16:57 web版本 zip包
    * 关联需求
        * [【手Q群查找】关键词数据上报优化](http://tapd.oa.com/v3/qqsearch_web/prong/stories/view/1010063621056068712?jumpfrom=RTX)


* 2014-04-14 16:00 zip包
    * 更新了一级分类数据的上报内容， 之前是上报索引， 后边改成了上报一级分类数据的id， 比如说 game 之类的


* 2014-04-15 16:00 web版本 zip包
    * 关联需求
        * [【查找入口】手Q查找二级分类打通](http://tapd.oa.com/v3/QQGroup/prong/stories/view/1010076071056076972?url_cache_key=746bd545a914162f83e18527c9db79b6&action_entry_type=story_tree_list)
        * 所有打开群部落的url， 在url里边添加当前时间戳，规避ios客户端的bug，有时候发布了zip包和web，手机仍有缓存，用户端无法更新


### [手Q客户端下载地址，发布历史，历代版本存在问题](/all/tencent/2014/04/15/mobile_qq_publish_history.html)

### 待优化

    前台控制用户搜索频率
    产品动向：
        进群量： 2200W
        主动   下降比率
        被动
    查找下一阶段主要任务：
    点击数据报群号
    搜索结果群号上报 结果集list
    上报信息中添加 cityid
    群资料卡 回流事件 通知到查找
    群资料卡 web开发   liveliang
    搜索请求带上经纬度


### 相关接口人
* 负责产品 jaytao, yugiwang, nicholeliu
* 群查找，接口人 amadeusguo
* 营销QQ数据 上海技术接口人 wallyzhang
* ios 客户端开发接口人 xiangruli
* android 客户端开发接口人 ippan yellowye
* cgi 接口人  wiliamwang  patternhe(何勇)
* 后台接口人 tangfutang
* 管理后台接口人 mabelzhang(张红梅)   管理后台前台开发：rehornchen
* 群，人 头像图片业务组员工  edzhong


### tomcat使用 cgi相关知识，可不了解
重启tomcat
sh /usr/local/java/webapps/q qfind_index/restart.sh

tomcat 存放查找首页的目录
/usr/local/java/webapps/q qfind_index/ROOT/WEB-INF/classes/index-pages

将当前目录的index.html 拷贝至159机器上 tomcat的查找首页目录下
scp index.html 10.12.23.159:/usr/local/java/webapps/q qfind_index/ROOT/WEB-INF/classes/index-pages/index.html
密码: pass4devnet

### nginx使用 前端服务器相关知识，可不了解
现在的nginx服务起在 /usr/local/services/目录下， 其实是软连接到了 /usr/local/tnginx, 配置啥的都到这个文件目录下修改， 修改完了如果需要重启nginx， /usr/local/services/tnginx_1_0_0-1.0/admin 下有一个 restart.sh

为什么使用腾讯改造过的nginx？

为了自动化收集CGI列表、静态页面和flash文件等信息进行上线前安全扫描，在内网收敛安全漏洞，需要在测试环境部署门神
QQ群这边的测试环境就要麻烦各位机器责任人帮忙部署了，需要部署的机器信息见下表

web server是 apache的话，部署文档见http://sec.itil.com/sec/home/index/4 的apache篇

nginx的话直接升级为下面已经编译了门神模块的nginx，qzhttp的话参考下面的帮助文档


### 原来项目在群中心的时候，他们写的readme文件，还没来得及整合
1.速度优化

    （2）可能感兴趣的群展示逻辑——
    原则是：缓存有且有效则用缓存，推荐群和附近的群两个TAB先拿到数据者先展示
    具体可参照方法[index.js]groupRequestManager()和LBSRequestManager()
    ng代表附近的群，rc代表推荐群

    （3）头像加载策略
    收集500ms，一次20个，通过CGI。其实可以直接拼凑头像，但是暂时没有弄懂其更新机制，没有引入。

    （4）js之所以inline，考虑：展示页面更完整，没有分段加载和无法响应的问题

    待做：
    （1）客户端接口监控
    （2）区分2G/3G和WIFI，进行不同的加载策略，尤其是预加载可能感兴趣的群（当前是滑动到临界区域就加载）
    （3）考虑：过多群的展示和隐藏问题，在较低端机型上存在滑动不流畅的问题


4.weinre
    推荐加载脚本 src = http://weinre.nohost.qq.com/target/target-script-min.js#[rtx-name]。Android使用时需要拦截替换模式，所以建议不要使用weinre.nohost.qq.com
    使用weinre后可以访问http://weinre.qq.com/client/#[rtx-name]

5.上报
    包含了monitor上报和DC上报，DC上报检查referer因此暂时采用了拦截替换模式。
    错误上报使用badjs

6.调试方法

    可以引入如下代码，实现一个显示条
    <script>
    (function(debug){
        if(debug){
            var div = document.createElement("div");
            document.body.appendChild(div);
            div.style.cssText = "position:fixed;z-index:99999;left:0;bottom:100px;width:100%;height:60px;overflow-y:auto;word-wrap:break-word;background:#ccc;";
            div.innerHTML = "<span onclick='window.location.reload()' style='color:#f00;font-weight:bold;cursor:pointer;display:block;'>reload</span>";
        }
            window.console = window.console || {};
        window.console.debug = function(s,b){
                if(debug){
                    if(b){
                        div.innerHTML += "<textarea>" + s + '</textarea><br/>';
                    }else{
                        div.innerHTML += s + '<br/>';
                    }
                }else{
                new Image().src="http://127.0.0.1:8080/?"+s;
                }
            };
        window.onerror = function (msg, url, line) {
            var info = [msg, url, line, window.navigator.userAgent].join('|_|');
            window.console.debug(info);
        };
    })(1);
    console.debug(1);
    </script>

    注：暂没提供PC调试，需要分模式进行数据加载，需要grunt支持


9.JsBridge
自己封装的小东西，手Q4.7之后可以使用公共资源的jsapi来做
存在两个方法：
(1)invokeClientMethod，IOS和Android通用。
传参采用p=JSON.stringify(JSON串)的格式。
除了Android加解密的接口不采用该格式，其它都是该格式

(2)invokeClientMethodByAndriod，Android专用
传参采用/[p1]/[p2]/[p3]...的格式。
Android加解密的接口采用该格式

10.客户端接口
通用commonAPI docs地址https://docs.google.com/document/d/1ti05nup1wgtEBX1PmJoB5DNB2jaCp8FBkdPXpL6agTc/edit?pli=1#

Android——————有本webview打开的webview可以复用，接口人:augustdong

(1)获取版本号(无参数调用)
JsBridge.invokeClientMethod('Troop', 'getVersion', callback(version) {
    // version Android QQ版本号
})

(2)查找群
JsBridge.invokeClientMethod('Troop', 'searchTroop', {
    keywords : '查询关键词',
    reportid : '来源id'
}, callback(result) {
    // result 调用成功/失败 true/false
})

(3)新开页面
JsBridge.invokeClientMethod('Troop', 'openUrl', {
    url : '链接'
}, callback(result) {
    // result 调用成功/失败 true/false
})

(4)打开群资料卡
JsBridge.invokeClientMethod('Troop', 'showTroopProfile', {
    gc : '群gcode',
    reportid : '来源id'
}, callback(result) {
    // result 调用成功/失败 true/false
})

(5)获取bkn
JsBridge.invokeClientMethod('Troop', 'getBkn', function (bkn) {
    // bkn basekey，对应算法固化到了客户端
})

(6)获取网络状态
JsBridge.invokeClientMethod('Troop', 'isNetworkConnected', function (result) {
    // result 网络是否开启 true/false
})

(7)获取定位服务打开状态
Android无需打开定位服务即可获取

(8)获取LBS数据
JsBridge.invokeClientMethodByAndriod('publicAccount', 'getRealLocationDes', ['{}', 'onGetLBSInfo'])
需要注册window.onGetLBSInfo方法，其数据经客户端Des加密，然后base64处理。前端为了配合CGI，做了个别字符的特殊处理
具体回调格式参照代码onGetLBSInfo

为什么Andriod需要加解密？因为Android获取LBS数据会携带用户敏感数据（手机号、imei），而IOS获取的是GPS数据，相比Android拿到数据后到soso后台获取校准的GPS数据，精确性要差一些。

IOS——————手Q4.6所有页面可以复用，接口人:kylewu
与Andriod类似，下面简单列一下：

(1)客户端接口
var qqVersion = JsBridge.invokeClientMethod('device', 'qqVersion')

(2)查找群
同Andorid

(3)新开页面
JsBridge.invokeClientMethod('nav', 'openLinkInNewWebView', {
    url : 'http://qun.qq.com/search/mobileqq/hotkey.html?_bid=118&tar=' + keywords,
    options : {
        styleCode : 4, //
        isNotRotate : 1 // 不允许横屏
    }
});

(4)打开群资料卡
同Andorid

(5)获取bkn
IOS可以获取cookie

(6)获取网络状态
var status = JsBridge.invokeClientMethod('device', 'networkStatus')
networkStatus  0：无网络：1：wifi；2：WWAN

(7)获取定位服务打开状态
var LBSstate = JsBridge.invokeClientMethod('data', 'getLBSState')
下为IOS客户端代码——
(NSNumber *)getLBSState:(NSDictionary *)parameters
{
    if (![CLLocationManager locationServicesEnabled])
    {   /*系统的定位关闭了*/
        return [NSNumber numberWithInt:0];
    }

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {   /*系统定位启动，但当前程序未选择是否可用定位服务*/
        return [NSNumber numberWithInt:1];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {   /*系统定位启动，但当前程序未被授权使用定位服务*/
        return [NSNumber numberWithInt:2];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {   /*系统定位启动，但当前程序明确不使用定位服务*/
        return [NSNumber numberWithInt:3];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {   /*系统定位启动，但当前程序授权使用定位服务*/
        return [NSNumber numberWithInt:4];
    }

    /*未知*/
    return [NSNumber numberWithInt:-1];
}

(8)获取LBS数据
JsBridge.invokeClientMethod('data', 'queryCurrentLocation', function (iAlt, iLat, iLon) {
    // iAlt 海拔
    // iLat 纬度
    // iLon 经度
});

11.CGI接口
测试环境 10.153.148.141 qun.qq.com
如有问题找wiliamwang，文档需要william提供
（1）加入公开群
http://qun.qq.com/cgi-bin/open_group/join_pub_group
（2）拉取附近的群
http://qun.qq.com/cgi-bin/promote_group/nearby_group_mobile
（3）拉取推荐群
http://qun.qq.com/cgi-bin/promote_group/recommend_group_mobile



[1]: http://tapd.oa.com/v3/Qplus/wikis/view/qq_mobile_find_env "web wiki"
[2]: http://tapd.oa.com/v3/QQConnectSys/wikis/view/CGI%2525E6%25258E%2525A5%2525E5%25258F%2525A3#toc1 "cgi wiki"
[3]: http://monitor.server.com/link/graph/viewid:6190 "monitor view"
[4]: http://m.isd.com/app/endusermonitor2/config/pointView.php?PHPSESSID=4eod1h9ai6nj910u3ek93sj7k6#date=2014-02-25&curTab=speed&productId=44101&serviceId=44101015&moduleId=388281&countryId=1&PHPSESSID=4eod1h9ai6nj910u3ek93sj7k6&flag1=7832&flag2=17&flag3=2 "performance view"
[5]: http://mm.isd.com/wns/wnsUsm.php#{"api":"wns_Usm.dDetailDimension","type":"table","data":{"date":"20140226","additional":{"appid":"1000154"},"groupby":"commandid"}}  "mm view"
[6]: http://webpc.oa.com/qqconnect/?ticket=778E4D57C8651EF31C9B87EF78C9B5E98E1E211C287CAFE18A8C402C5FFE4961AC618BDCC843138044B7A03FB6E50A4509D1C7A3EC33253CA8B424EF034A6555236C84962E065B7416DFF077662D7AE77A71FC9F286943C0150909966B5099D5E2D35AFC2103BAA91C1F91946B650E2280EC4BEAE5643DE0C40CD4C5D14937D8F631608651A95540718286DFB26FC2473AA22D1CD37B3D875214F91FC1CE1E5D3793DAD9C954611D5BBE4CA81CE402F05047C5CDF3C2DAD1B2E7BBAFBE6CBF1C&loginParam=disposed&length=35&lengh=35&sessionKey=778E4D57C8651EF31C9B87EF78C9B5E98E1E211C287CAFE18A8C402C5FFE4961AC618BDCC84313803A545E8300C3BABE  "伯努利 view"
[7]: http://gruntjs.com/ "grunt Official website"
[8]: http://www.smushit.com/
[9]: http://rubyinstaller.org/ "rubyinstall website"
[10]: http://oz.isd.com/index.php?menuId=15230&auth_cm_com_ticket=f3970759-e615-49bd-b253-0b464d911001
[11]:http://rdm.wsd.com/DailyBuild.html?v=ci.myview&t=&f=developTools#ci.jobdynamic@rdmProjectId:74ff62b6-c6bd-46ef-b268-a39ceb4f1f16;jobId:2821@ci.joblist@1394591648687
[12]:http://rdm.wsd.com/DailyBuild.html?v=ci.myview&t=&f=developTools#ci.planview@rdmProjectId:6ada9bb1-f73c-405a-b528-fa5a59df2a2f@@1394597145623
[13]:http://mqq.oa.com/
[14]:https://docs.google.com/document/d/1cCKbqxZ0TMV31aC6uT-icY2Kn43VGTzAW5WBBFgwXpc/edit?pli=1#heading=h.xhntumzigujf
[15]:https://docs.google.com/spreadsheet/ccc?key=0AnSPazf9T6tAdG5XQmhTVG5JVWt0a2VwWWxaMk5qSkE&usp=drive_web#gid=0 "每人手头机器"
[16]:/all/web/2014/03/17/在项目中使用预编译jade模板.html
[17]:/all/web/2014/03/17/在项目中使用预编译handlebars模板.html