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
- ARM64 ✅

---

# 使用方法

## 0. 系统需要拥有

Ruby3 提供 Rake

## 1. rake -T 查看可用命令

```
➜  build git:(main) rake -T
rake build               # build program
rake build_merge         # merge program in build
rake build_to_c          # build to c code
rake cache_merge         # merge program in cache
rake clean               # clean
rake init_build          # init build dir
rake init_cache          # init develop cache dir
rake mruby:build         # build mruby
rake mruby:build_config  # replace mruby build config
rake mruby:custom_build  # custom config build mruby
rake mruby:download      # download mruby
rake mruby:init          # init
rake run                 # run program
```

## 1.模仿 golang 的 go run

`rake run`

## 2.模仿 golang 的 go build

`rake build`

## 3.交叉编译的包

借助 Github Action 在 main 分支推送后，查看 Action 构建任务，下载产物

## TODO

- [x] 交叉编译
- [x] 多文件

## 约定

- `src/main.rb` 是入口文件
- `src/lib/*.rb` 是依赖文件

程序会把 `lib/*.rb` 合并 最后和 main.rb 合成一个文件，进行 build

这对程序的组织、复杂度都有会对应的要求。需要自己控制复杂的依赖关系。

没有引入额外复杂的 makefile，也不想耦合进入 MRuby 的构建过程。

有依赖关系的尽可能写在一个文件。 lib 中的文件应该可以 无顺序要求引入。最后汇总在 main.rb 进行聚合。

lib 中声明关键的类、模块。main.rb 声明的是主体逻辑。
