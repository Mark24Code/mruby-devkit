# mruby-devkit

mruby devkit

灵感来自于 Golang 可以编译语言成为二进制。

使用 MRuby。DevKit 借助 Rake 可以方便的把 Ruby 代码简化编译成二进制产物。

---

测试：

Mac Intel X64 ✅

---

# 使用方法

## 1. rake -T 查看可用命令

```
➜  build git:(main) rake -T
rake build[enter,output]  # build program
rake compiler:build       # build mruby
rake compiler:download    # download mruby
rake init                 # init
rake install              # install
rake run[enter]           # run program
```

## 2.初次使用

`rake init` 初始化编译器

## 3.模仿 golang 的 go run

`rake 'run[main.rb]'`

## 4.模仿 golang 的 go build

`rake 'build[main.rb]'`

## TODO

- [ ] 交叉编译
- [ ] 添加基本的 gem
