---
title: hexo-butterfly
date: 2022-06-02 09:50:58
tags: 
    - 服务器部署
    - 教程
author:     "Ming Huang"
categories: 个人博客的搭建
description: Hexo(butterfly)搭建过程
top_img: 
cover: https://z3.ax1x.com/2021/01/30/yka3j0.jpg
---

## 前言

之前利用HuxPro做过一个私人的博客，但是感觉太单调了，趁着这次机会试试其他的博客主题。这次尝试了下用hexo以及使用butterfly主题。最开始尝试了melody，但是总是不显示博文，实在找不到原因就放弃了。用butterfly倒是蛮顺利的。下面是主要流程

## 流程

本流程主要参考的是[Hexo官方文档](https://hexo.io/zh-cn/index.html)和[Confucianmen大宇](https://www.jianshu.com/p/50a565adaf15)。其他一些参考链接[ShanGuBlog](http://shangu127.top/2021/01/28/博客搭建/#芜湖起飞), [Moqiqiuzi](https://blog.csdn.net/qq_43857095/article/details/108306164)

1. 安装Hexo
    安装Hexo，要先安装node.js和npm。ubuntu的话可以直接`sudo apt install nodejs npm`。但是nodejs版本可能不够，ubuntu软件源的为10.19.0。其他Nodejs的版本可以通过NodeSource中获得。方法如下
        ```
        sudo npm install n -g
        sudo n stable
        hash -r 
        # 完成后重启
        ```
    安装完nodeJs和npm之后开始安装hexo `npm install hexo-cli -g`

1. 初始化博客
    到想要的文件夹下面执行`hexo init blog`

1. 安装主题， 配置以及安装渲染插件
    ```
    npm i hexo-theme-butterfly # 安装butterfly主题， hexo version> 5, 小于5，需要单独下载
    # 修改默认主题 _config.yml 中找到"theme: landscape" 改成"theme: butterfly"
    npm install hexo-renderer-pug hexo-renderer-stylus --save
    cp node_modules/hexo-theme-butterfly/_config.yml _config.butterfly.yml # 方便修改
    ```

1. 配置主题
    修改_config.butterfly.yml中的部分配置，详细可参考[大宇的分享](https://www.jianshu.com/p/50a565adaf15)

1. 启动本地网站
    ```
    hexo c && hexo g && hexo s # clean, generate static web and start server
    ```

## 其他操作
- 引用不需要渲染的html文件
    有时候模板不一定能够涵盖网页的所有特征，所以需要一些自定义的html文件。参考文章[Chak Aciano](https://blog.csdn.net/weixin_58068682/article/details/116611715) 添加自定义html页面
    1. 添加在source文件夹下建立一个新的文件夹(如demo)
        `hexo new page demo`
    1. 在_config.yml中设置跳过渲染
        ```
        skip_render: 
            - 'demo/*'
        ```
    1. 简单的方法是建立一个链接关系，如在其他.md文件建立一个引用`[xxx](demo/xxx.html)`。复杂的方法可参考[Chak](https://blog.csdn.net/weixin_58068682/article/details/116611715)

- 插入图片
    - 对于一些经常重复使用的图片，可以放在文件夹`node_modules/hexo-theme-butterfly/source/img`中，引用方式为`/img/404-bg.jpg`

    - 如果是网络上的图片，可以通过`![XXX](https:XXX)`

    - 对于一些临时插入的仅限于当前文章的图片，实现方式需要插件`hexo-asset-image`
        - 将`_config.yml`文件中的`post_asset_folder`设置为true，
        `relative_link`设置为true
        - 下载插件，网上教程是说用`npm install hexo-asset-image --save`，但是我用了不好使。这里使用了[_小江_](https://blog.csdn.net/m0_43401436/article/details/107191688)建议的`npm install https://github.com/CodeFalling/hexo-asset-image --save`
        - 在.md文件的对应文件夹内建立相同名字的文件夹，并将图片放入到文件夹中。
        - 然后在文章中引用例如`![demo](demo.jpg)`。这里只需要填写文件名，不需要写其他的相对路径，插件会在`hexo g`过程中自动补全相对路径。需要在_post建立子文件夹，并且子文件夹需要回避一些关键词，比如日期(2020, 2022等)，server。我测试出来这两个，如果使用这两个，hexo-asset-image做路径替代和补全的时候会出现问题
        ![demo](demo.jpg)

- 部署到git端
    参考资料[XJHui](https://www.cnblogs.com/ldu-xingjiahui/p/12594025.html)
    1. 安装git插件
        ```npm install --save hexo-deployer-git```
    2. 修改配置文件
        ```
        vi _config.yml <- 在最先面添加以下设置
        deploy：
            type: git
            repo: git@github.com:XXX.io.git # 不要用https，否则会要求使用账号密码，而git现在已经不支持personal passwd了
            branch: master
        ```
    3. 部署到远端
        ```
        hexo clean
        hexo g
        hexo d
        ```
