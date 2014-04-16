---
layout: post
title: 2014-04-14-手机web各机型适配经验.md
---

#### 各机型适配经验

1. 每人手头机器 [访问][15]

2. android 2.2 2.3机器不支持直接配置wifi代理， 可以考虑使用第三方代理软件 ProxyDroid

3. android 2.3 及之前机器 不支持html元素 添加 hidden 属性

4. android 2.3 及之前机器 不支持 input元素的 padding-top padding-bottom 属性

5. 部分android 不支持 input元素的keyup事件， 统一使用 input 事件
    <pre class="brush: js">
        $("search-box").addEventListener("input", function (event) {
            correctApperanceDepUserInput("keyup");
        });
    </pre>

6. android2.3 不支持html5新属性 - dataset 解决方案：
    <pre class="brush: js">
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>getDataset(android 2.3不支持HTML5新属性--dataset)</title>
        </head>
        <body>
          <a id="js-dataset" href="javascript:;" data-username="ocean" data-gender="male" data-hobby="loving girl"></a>

          <script type="text/javascript">
          function $(id) {
            return (typeof id === 'string' ? document.getElementById(id) : id);
          }

          function getDataset(elem, attr) {
            if(typeof elem.dataset !== 'undefined') {
              return attr ? elem.dataset[attr] : elem.dataset;
            } else {

              var obj = {};
              var attrs = $(elem).attributes;
              console.log(attrs);
              // return;
              if(attrs.length) {
                for(var i=0, len=attrs.length; i<len; i++) {
                  var current = attrs[i];
                  if(current.name.indexOf('data-') !== -1) {
                    obj[current.name.replace('data-', '')] = current.value;
                  }
                }
                return attr ? obj[attr] : obj;
              }

            }
          }

          console.log( getDataset('js-dataset') );
          console.log( getDataset('js-dataset', 'hobby') );
          </script>
        </body>
        </html>
    </pre>

7. 检测安卓版本在2.3之上的代码片段
    <pre class="brush: js">
        (function () {
            // 为 mobile 环境做一些适配

            var ua = navigator.userAgent;
            $.isAndroid = /(Android)/i.test(ua);
            $.isIOS = /(iPhone|iPad|iPod|iOS)/i.test(ua);

            var wkmatch = ua.match(/AppleWebKit\/([0-9]+)/);
            alert(ua);
            var wkVersion = !!wkmatch && wkmatch[1];
            var isBadAndroid = ua.indexOf('Android') > -1 && wkVersion < 534;


            alert(wkVersion);

            if (isBadAndroid) {
                // 是否具有打开群部落接口的能力
                $.canInvokeTribeInterface = false;
            } else {
                $.canInvokeTribeInterface = true;
            }

        }());
    </pre>


8. Android 2.3一下不支持 classList 获取元素的class列表， 采用以下方式：

    ```javascript
        hasClass:function(elem,className){
            if (!elem || !className) {
                return false;
            }
            if(elem.classList)
                return elem.classList.contains(className);
            else
                return -1 < (' ' + elem.className + ' ').indexOf(' ' + className + ' ');
        },
        addClass:function(elem,className){
            if (!elem || !className || Q.util.hasClass(elem, className)){
                return;
            }
            if(elem.classList)
                elem.classList.add(className);
            else
                elem.className += " "+ className;
        },
        removeClass:function(elem,className){
            if (!elem || !className || !Q.util.hasClass(elem, className)) {
                return;
            }
            if(elem.classList)
                elem.classList.remove(className);
            else
                elem.className = elem.className.replace(new RegExp('(?:^|\\s)' + className + '(?:\\s|$)'), ' ');
        },
    ```

9. Android 不支持对 div 出滚动条进行滚动，4.0以上才支持的，不过支持的并不好,没有滚动惯性 iOS也需要iOS5以上才对div出滚动条
