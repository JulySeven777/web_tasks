#!/usr/bin/ruby
# -*- coding: UTF-8 -*-

class Student
  attr_accessor :stu_id,:stu_name,:stu_gender,:stu_age  #使用访问器来对类成员变量进行访问
  def initialize(id, name,gender,age)  #构造函数
    @stu_id=id
    @stu_name=name
    @stu_gender=gender
		@stu_age=age
  end

  def to_s
		"id:#@stu_id      name:#@stu_name     gender:#@stu_gender     age:#@stu_age"
  end
end



def newgender() #随机数字函数来决定学生的性别
  male="male"
  female="female"
  gen=rand(0..99)
  if gen>=50 then return male
  else return female
  end
end


def newname(len)  #随机字符串产生函数生成长度为len的学生姓名
  chars=("a".."z").to_a+("A".."Z").to_a+("0".."9").to_a
  newname=""
  1.upto(len){|i|newname<<chars[rand(chars.size-1)]}
  return newname
end


def sort_byid(a)  #用sort_byid（）函数实现根据id大小排序 并用迭代器进行输出
  a1=a.sort_by{|a| a.stu_id.to_s.downcase}
  a.each do |i|
	   puts i
	 end
end


def sort_byname(a)    #用sort_byname（）函数实现根据姓名字典序大小排序 并用迭代器进行输出
  a1=a.sort_by{|a| a.stu_name.downcase}
  a1.each do |i|
	    puts i
	  end
end


def sort_byage(a)   #用sort_byage（）函数实现根据年龄大小排序  并用迭代器进行输出
  a1=a.sort_by{|a| a.stu_age.to_s.downcase}
  a1.each do |i|
            puts i
          end
end


 #以学生类实例对象为值 创建数组a
stu=Student.new(100,"STU".to_s+newname(15),newgender(),rand(15..20))
a= Array.new(100,stu)

#用迭代器生成100个学生类实例对象 加入数组a
100.times{|index|stu=Student.new(100-index,"STU".to_s+newname(15),newgender(),rand(15..20));a[100-index]=stu}

#100.times{|index|puts "#{a[index]}"}


puts"---------------------------"
puts("100个学生已初始化完成！")
puts"---------------------------"




puts("请输入要执行的操作：")            #进行增查改删操作选择
puts("增--1")
puts("查--2")
puts("改--3")
puts("删--4")
puts("排序--5")



x=gets.chomp

if(x.to_s=="1")                   #插入操作 在Array表中 先预判该同学是否存在
  puts("请输入该插入同学的学号:")
  id=gets.chomp
  id=id.to_i
    if a[id]!=nil then puts"该同学已存在！"
    else
      puts("请输入该插入同学的姓名:")
      name=gets.chomp
      puts("请输入该插入同学的性别:")
      gender=gets.chomp
      puts("请输入该插入同学的年龄:")
      age=gets.chomp
      age=age.to_i
      stu=Student.new(id,name,gender,age)
      a[id]=stu
    end
end


if(x.to_s=="2")           #查询操作 在Array表中 先预判该同学是否存在
  puts("请输入该查询同学的学号:")
  seekid=gets.chomp
  seekid=seekid.to_i
  if a[seekid]==nil  then puts"该同学不存在！"
  else
    puts("该同学姓名：#{a[seekid.to_i].stu_name}")
    puts("该同学性别：#{a[seekid.to_i].stu_gender}")
    puts("该同学年龄：#{a[seekid.to_i].stu_age}")
  end
end


if(x.to_s=="3")           #修改操作 在Array表中 先预判该同学是否存在
  puts("请输入该修改同学的学号:")
  seekid=gets.chomp
  seekid=seekid.to_i
  if a[seekid]=nil  then puts"该同学不存在！"
  else
    puts("请输入该修改同学的姓名:")
    name=gets.chomp
    puts("请输入该修改同学的性别:")
    gender=gets.chomp
    puts("请输入该修改同学的年龄:")
    age=gets.chomp
    age=age.to_i
    a[seekid]=Student.new(seekid,name,gender,age)
  end
end


if(x.to_s=="4")            #删除操作 在Array中 先预判该同学是否存在
  puts("请输入该删除同学的学号:")
  seekid=gets.chomp
  seekid=seekid.to_i
  if a[seekid]==nil  then puts"该同学不存在！"
  else
    a.delete_at(seekid)
  end
end


if(x.to_s=="5")        #排序操作
  puts("排序输出：")
  puts("按id排序--1")
  puts("按姓名排序--2")
  puts("按年龄排序--3")
  puts("请输入排序方式：")
  sort=gets.chomp
  if sort=="1"
    sort_byid(a);
  elsif sort=="2"
    sort_byname(a);
  elsif sort=="3"
    sort_byage(a);
  end
end

#100.times{|index|puts "#{a[index]}"}


#保存成yml文件功能未实现
#require 'yaml'
#stu = YAML.load(File.open("student.yml"))
#puts "student id is #{stu["stu"]["id"]}"
#puts "student name is #{stu["stu"]["name"]}"
#puts "student gender is #{stu["stu"]["gender"]}"
#puts "student age is #{stu["stu"]["age"]}"
