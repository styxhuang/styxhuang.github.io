---
title: redmine 安装
subtitle:   "redmine Installation"
date: 2022-05-01
author:     "Ming Huang"
tags: 
    - 服务器部署
    - 教程
categories: 个人博客的搭建
top_img: /img/post-bg-2015.jpg
cover: https://z3.ax1x.com/2021/01/30/yka3j0.jpg
---

## 前言

之前在北京做软件开发的时候，团队使用的redmine对整个项目进行管理，并且和gitlab私有库进行链接同步。觉得很方便。就在自己新搭建的本地服务器尝试重新安装一下。

## 流程

本流程主要参考的是redmine[官方流程](https://www.redmine.org/projects/redmine/wiki/RedmineInstall) 以及[zhao_ning_ha](https://blog.csdn.net/zhao_ning_ha/article/details/70240437)提供的流程。

目前还是习惯使用ubuntu系统。这次也是在ubuntu 20.04上进行安装，唯一有不同的是使用的是ARM64结构的硬件。所以整体的ubuntu相关软件也都需要和arm64 arch兼容。

根据官方的文档，redmine需要 ruby, rail, mysql。其中数据库还可以是PostgreSQL, Microsoft SQL server以及SQLite

1. 安装ruby, rails和mysql
    ```
    sudo apt update
    sudo apt install ruby
    sudo gem install rails
    sudo apt install mysql-server mysql-client
    ```
1. 设置数据库。虽然官网说了MySQL> 5.5.2, 可以使用utf8mb4, 但是我在初始化数redmine数据库的时候还是报错了。`Mysql2::Error: Table 'redmine.roles' doesn't exist: SHOW FULL FIELDS FROM ``roles`` Default configuration data was not loaded.`所以建议大家还是使用utf8
    ```
    > mysql 
        CREATE DATABASE redmine CHARACTER SET utf8;
        CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'my_password';
        GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';
    ```
    其中redmine为数据库的用户名， my_password是密码
1. 下载redmine的[源码](https://www.redmine.org/projects/redmine/wiki/Download) 并进行配置
    ```
    wget https://www.redmine.org/releases/redmine-4.2.6.tar.gz
    tar -xvf redmine-4.2.6.tar.gz
    cd redmine-4.2.6
    cp config/database.yml.example config/database.yml
    vi config/database.yml

    # 确定production配置。需要和上面的sql的数据库对应参数相同
    # 以下为database.yml修改的部分
    production:
        adapter: mysql2
        database: redmine
        host: localhost
        username: redmine
        password: "my_password" 
    ```
1. 配置gem依赖
    ```
    gem install bundler
    bundle install --without development test 
    ```
    如果运气好的话，以上命令就可以将相关的gem依赖安装完。但如果出现错误，用一下的方法依次安装依赖
    ```
    sudo apt install ruby-dev # 可以解决一部分依赖安装的问题
    gem install bundler
    sudo apt install imagemagick libmagickwand-dev
    gem install rmagick
    sudo apt install mysql-client libmysqlclient-dev
    gem install mysql2 
    gem install nokogiri
    sudo apt install libxslt-dev libxml2-dev
    bundle install # 如果此处出现错误，根据提示逐个解决
    ```
1. 初始化数据库
    ```
    rake generate_secret_token
    RAILS_ENV=production bundle exec rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en bundle exec rake redmine:load_default_data 
    # 如果这个命令出现错误尝试
    rake db:migrate RAILS_ENV=production
    ```
1. 修改文件权限
    ```
    mkdir -p tmp tmp/pdf public/plugin_assets
    # redmine 是用户名以及分组的名字，可以自行设置
    sudo chown -R redmine:redmine files log tmp public/plugin_assets
    sudo chmod -R 755 files log tmp public/plugin_assets
    ```
1. 测试是否安装成功
    ```
    bundle exec rails server webrick -e production
    # localhost: 默认是127.0.0.1, 但是要看本身的ip地址，ifconfig可以看到
    ```
1. 配置vscode server
   下载code-server， 这里我需要下载的事arm架构的server。下载好后无需安装，先解压之后运行bin文件夹下的/code-server，他会生成一个默认的配置文件，将其中的文件中的端口修改一下。我这里修改为```0.0.0.0:8686```。密码修改为需要的。然后再重新运行code-server。就可以到浏览器中使用```服务器IP：8686```进行网页端的vscode进行编程了。