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


$i=21

def newname(len)  #随机字符串产生函数生成长度为len的消息
  chars=("a".."z").to_a+("A".."Z").to_a+("0".."9").to_a
  newname=""
  1.upto(len){|i|newname<<chars[rand(chars.size-1)]}
  return newname
end

#mas=Massage.new(0,"AUTHOR".to_s+newname(15),"MASS".to_s+newname(20))
$a= Array.new#(50,mas)



require 'yaml'
if File.exist?("massages.yml")          #先判断student.yml文件是否存在 若存在 则将其信息引入到a
	puts "该massages.yml表已存在!正在载入表内信息..."
	res = YAML.load(File.open("massages.yml"))
	res.each do |i|
	           $a[i. id]=i;
						#$a.push i
                 end
	puts"信息已载入完成..."

else                                 #不存在的话就新生成100个学生信息
	puts "该massages.yml表不存在！新生成留言信息！"
	20.times{|index|mas=Massage.new(index+1,"AUTHOR".to_s+newname(15),"MASS".to_s+newname(20));$a[index+1]=mas;sleep 5}#sleep 0.1
	puts"---------------------------"
	puts("20条留言已初始化完成！")
	puts"---------------------------"
	File.open('massages.yml', 'w') do |os|         #将a放入student.yaml中
                                  YAML::dump(a, os)
                                end
end



class DealMassage
  attr_accessor :id,:author,:massage,:time  #使用访问器来对类成员变量进行访问

	def add_mas(author,massage)
	  mas=Massage.new($i,author,massage)
		$i=$i+1
		$a.push mas
		return $i
	end

	def delete_at(id)
		if $a[id]==nil  then return '该留言id不存在！'
		else $a.delete_at(id)
		end
		return "删除成功！"
	end

	def delete(array)
		cnt=0
		res=Array.new
		array.each do|i|
			i=i.to_i
										if $a[i]==nil
											hint='编号为'+i.to_s+'的留言不存在！'
											res.push hint
										else
											$a.delete_at(i)
											hint='成功删除编号为'+i.to_s+'的留言！'
											res.push hint
											cnt=cnt+1
									 end
		           end
		return [cnt,res]
	end


	def search_byid(id)
	  if ($a[id]==nil) then return  [0,'该留言id不存在！'] # @error='该留言id不存在！';@flag=0
	  else
			return [1,$a[id].massage]
	  end
  end

	def search_byauthor(author)
		cnt=0
		result=Array.new
		$a.each do|i|
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
	a.each do |i|
		 			puts i
	 			end
end

def sort_bytime(a)  #用sort_byid（）函数实现根据id大小排序 并用迭代器进行输出
	a1=a.sort_by{|a| a.time.to_s.downcase}
	a.each do |i|
		 puts i
	 end
end




require 'sinatra'


configure do
	set :username, 'sinatra'
  set :password, 'sinatra'

end



get '/' do
		a1=$a.sort_by{|a| a.time.to_s.downcase}
		@massages=a1
    erb :getMassages
end

post '/add' do
	if params[:massage].to_s.length>=10&&params[:author].length>0
		addV=DealMassage.new()
		id=addV.add_mas(params[:author],params[:massage])
		@id=id
		@author=params[:author]
		@massage=params[:massage]
		erb :success
	else
		if params[:author].length<=0
			 @error='必须有留言者姓名！'
		else @error='留言长度必须不小于10！'
		end
		erb :addError
	end
end



post '/delete' do
	del=DealMassage.new()
	s=del.delete_at(params[:hiddenid].to_i)
	@id=params[:hiddenid].to_i
	@s=s
	erb :delete
end


get '/delete/:id' do
		s=params['id']
		array=s.split(" ")
		del=DealMassage.new()
		@cnt,@res=del.delete(array)
	erb :delete_array
end




get '/search' do
	if params[:id].length<=0&&params[:author].length<=0
		  @hint="请输入留言id或留言者姓名"
			@flag=0
	elsif params[:id].length!=0&&params[:author].length==0
		search=DealMassage.new()
		@flag,@hint=search.search_byid(params[:id].chomp.to_i)
	elsif params[:id].length==0&&params[:author].length!=0
		search=DealMassage.new()
		@flag,@hint=search.search_byauthor(params[:author].chomp.to_s)
		if(@flag==2)
			if(params[:choice].to_i==1)
				@hint=sort_byid(@hint)
			elsif params[:choice].to_i==2
				@hint=sort_bytime(@hint)
			end
		end
	end
	@id=params[:id]
	@author=params[:author]
	erb :search
end
