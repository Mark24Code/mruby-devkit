# mruby-devkit

mruby devkit

灵感来自于 Golang 可以编译为二进制可执行文件。 devkit 提供一个简易的脚手架，使用 Ruby 程序也可以打包成二进制可执行文件。

---

测试：

MacOS

- AMD64 ✅
- ARM64 ✅

Debian/Ubuntu/Mint Linux

- AMD64 ✅

---

# 使用方法

## 0. 系统需要拥有

Ruby3 提供 Rake

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
- [ ] 将编译器编译成 portable mruby 跳过本地编译
- [x] 多文件

## 约定

- `src/main.rb` 是入口文件
- `src/lib/*.rb` 是依赖文件

程序会把 `lib/*.rb` 合并 最后和 main.rb 合成一个文件，进行 build

这对程序的组织、复杂度都有会对应的要求。需要自己控制复杂的依赖关系。

没有引入额外复杂的 makefile，也不想耦合进入 MRuby 的构建过程。
