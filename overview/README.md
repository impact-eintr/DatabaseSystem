# 数据库导论

数据库在现实生活中非常重要，所谓数据库，即它是以某种方式去进行关联的数据集合
一个简单的数据库程序可以组织csv, json等文本文件，然后编写程序和方法，以此来读取我们需要的信息来回答问题，或者对他们进行查询

比如我们有两个实体
- 作者

``` json
{name:"eintr", year:1999, contry:"China"}
{name:"zhangsan", year:1994, contry:"China"}
{name:"Mike", year:1989, contry:"USA"}
```

- 作品

``` json
{name:"摸鱼的艺术", author:"eintr", 2021}
{name:"犯罪的艺术", author:"zhangsan", 2018}
{name:"加班的艺术", author:"Mike", 2002}
```


对于这样的数据，我们可以简单地写程序，逐行遍历，但有两个问题
- 如何确保在程序执行中，对于每个作品来讲，要确保作者所在的作品中的位置都要相同。




































