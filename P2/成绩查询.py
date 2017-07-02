#采用python3语言
#用cookie和虚拟表头来获取自己教务系统中的成绩信息
#用正则表达式来提取网页中的信息 最后输出

# coding:utf8

import re
import urllib
import urllib.request 
import urllib.error
import http.cookiejar 

loginUrl = 'http://202.119.113.135/loginAction.do' #校网登陆页面

#cookie
cookie = http.cookiejar.CookieJar()
handler = urllib.request.HTTPCookieProcessor(cookie)
opener = urllib.request.build_opener(handler)


#postdata 分析网页 获取post表单
values = {
    'zjh':'1506010305',
    'mm':'1506010305',
    'v_yzm':''
}
postdata = urllib.parse.urlencode(values).encode(encoding='UTF8')

#headers 伪造头部或者Header信息
header = {
    'User-Agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36',
    'Referer':'http://202.119.113.135/loginAction.do'
}

#第一次请求网页得到cookie
request = urllib.request.Request(loginUrl,postdata,headers=header)
response = opener.open(request)
print('第一次请求网页得到cookie:')
print (response.getcode())

#获取验证码 用带cookie的方法访问验证码的网页---进入的验证码的页面 加载验证码图片到yzm.jpg，对应的验证码就是登陆页面的验证码
yzm = opener.open('http://202.119.113.135/validateCodeAction.do')
yzm_data =  yzm.read()
with open('yzm.jpg','wb')as fp:
		fp.write(yzm_data)


#用户输入验证码
values['v_yzm'] = input('请输入图中的验证码:')


#带验证码模拟登陆
postdata = urllib.parse.urlencode(values).encode(encoding='UTF8')
request = urllib.request.Request(loginUrl,postdata,header)
response = opener.open(request)
print ('Response of loginAction.do')
#print (response.read().decode('gbk')) 打印查看是否成功登陆


#获取成绩
top_url = 'http://202.119.113.135/gradeLnAllAction.do?type=ln&oper=sxinfo&lnsxdm=001'
direct_url=top_url.encode(encoding='UTF8')
response = opener.open(direct_url.decode('gbk'))
content = response.read().decode('gbk')
#print('conten ',content) 打印查看是否成功连接成绩页面


#通过正则表达式进行匹配
#<tr.*?class="odd".*?</td>.*?</td>.*?<td align="center">(.*?)</td>.*?<p align="center">(.*?)&nbsp;</P>'--只看名称和分数
pattern = re.compile('<tr class="odd".*?</td>.*?</td>.*?<td align="center">(.*?)</td>.*?<td.*?</td>.*?<td.*?</td>.*?<td align="center">(.*?)</td>.*?<p align="center">(.*?)&nbsp;</P>', re.S)
grades = re.findall(pattern, content)
for grade in grades:
	print('课程名称：',grade[0])
	print('课程性质：',grade[1])
	print('课程成绩：',grade[2])
	print('\n')
