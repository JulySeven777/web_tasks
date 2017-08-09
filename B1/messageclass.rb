class Massage
  attr_accessor :id,:author,:massage,:time  #使用访问器来对类成员变量进行访问
  def initialize(id,author,massage)  #构造函数
    @id=id
    @author=author
    @massage=massage
    @time=Time.new
  end

  def to_s
    "id:#@id      author:#@author     massage:#@massage     time:#@time"
  end
end

$amount=21
$messageArray= Array.new

class DealMassage
  attr_accessor :id,:author,:massage,:time  #使用访问器来对类成员变量进行访问

	def add_mas(author,massage)
	  mas=Massage.new($amount,author,massage)
		$amount=$amount+1
		$messageArray.push mas
		return $amount
	end

	def delete_at(id)
		flag=0
		$messageArray.each do|i|
		  if i.id==id
			    flag=1
					tmp=i
					$messageArray.delete(tmp)
				end
			end
		if flag==0  then return [0,'编号为'+id.to_s+'的留言不存在！']
		else return [1,'成功删除编号为'+id.to_s+'的留言！']
		end
	end

	def delete(array)
		cnt=0
		res=Array.new
		array.each do|i|
			  i=i.to_i
				flag,hint=delete_at(i)
				res.push hint
				cnt=cnt+flag
		 end
		return [cnt,res]
	end


	def search_byid(id)
	  if ($messageArray[id]==nil) then return  [0,'该留言id不存在！'] # @error='该留言id不存在！';@flag=0
	  else
			return [1,$messageArray[id].massage]
	  end
  end

	def search_byauthor(author)
		cnt=0
		result=Array.new
		$messageArray.each do|i|
						 if i.author.chomp.to_s==author.chomp.to_s
							 result[cnt]=i
							 cnt=cnt+1
						 end
					 end
		   if(cnt==0)
			   return[0,'该留言者不存在！']
		  else
				return[2,result]
			end
	end
end



def sort_byid(a)  #用sort_byid（）函数实现根据id大小排序 并用迭代器进行输出
	a1=a.sort_by{|a| a.id.to_s.downcase}
end

def sort_bytime(a)  #用sort_byid（）函数实现根据id大小排序 并用迭代器进行输出
	a1=a.sort_by{|a| a.time.to_s.downcase}
end


def newname(len)  #随机字符串产生函数生成长度为len的消息
  chars=("0".."9").to_a
  newname=""
  1.upto(len){|i|newname<<chars[rand(chars.size-1)]}
  return newname
end


require 'yaml'
if File.exist?("massages.yml")          #先判断massages.yml文件是否存在 若存在 则将其信息引入到a
	puts "该massages.yml表已存在!正在载入表内信息..."
	res = YAML.load(File.open("massages.yml"))
	res.each do |i|
	           $messageArray[i. id]=i;
                 end
	puts"信息已载入完成..."

else                                 #不存在的话就新生成20条留言信息
	puts "该massages.yml表不存在！新生成留言信息！"
	20.times{|index|mas=Massage.new(index+1,"AUTHOR".to_s+newname(3),"MESSAGE".to_s+newname(20));$messageArray[index+1]=mas}#sleep 0.1
	puts"---------------------------"
	puts("20条留言已初始化完成！")
	puts"---------------------------"
	File.open('massages.yml', 'w')do |os|         #将a放入student.yaml中
      YAML::dump($Sa, os)
    end
end
